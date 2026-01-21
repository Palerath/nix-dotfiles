#!/usr/bin/env bash
# Comprehensive GPU Passthrough Check for GTX 1650

echo "=========================================="
echo "GPU PASSTHROUGH CONFIGURATION CHECK"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Expected PCI IDs for GTX 1650
GTX1650_GPU="10de:1f82"
GTX1650_AUDIO="10de:10fa"

echo -e "${BLUE}=== 1. Kernel Parameters Check ===${NC}"
echo "Current kernel command line:"
cat /proc/cmdline | grep -o "amd_iommu=[^ ]*\|iommu=[^ ]*\|vfio-pci.ids=[^ ]*" || echo -e "${RED}No VFIO parameters found!${NC}"
echo ""

echo -e "${BLUE}=== 2. VFIO Modules Loaded ===${NC}"
if lsmod | grep -q vfio_pci; then
    echo -e "${GREEN}✓ vfio_pci module loaded${NC}"
else
    echo -e "${RED}✗ vfio_pci module NOT loaded${NC}"
fi

if lsmod | grep -q vfio_iommu_type1; then
    echo -e "${GREEN}✓ vfio_iommu_type1 module loaded${NC}"
else
    echo -e "${RED}✗ vfio_iommu_type1 module NOT loaded${NC}"
fi
echo ""

echo -e "${BLUE}=== 3. GTX 1650 Device Detection ===${NC}"
GTX1650_BUS=$(lspci -nn | grep -i "$GTX1650_GPU" | cut -d' ' -f1)
if [ -n "$GTX1650_BUS" ]; then
    echo -e "${GREEN}✓ GTX 1650 GPU found at: $GTX1650_BUS${NC}"
    lspci -nnk -s "$GTX1650_BUS"
else
    echo -e "${RED}✗ GTX 1650 GPU not found!${NC}"
fi
echo ""

GTX1650_AUDIO_BUS=$(lspci -nn | grep -i "$GTX1650_AUDIO" | cut -d' ' -f1)
if [ -n "$GTX1650_AUDIO_BUS" ]; then
    echo -e "${GREEN}✓ GTX 1650 Audio found at: $GTX1650_AUDIO_BUS${NC}"
    lspci -nnk -s "$GTX1650_AUDIO_BUS"
else
    echo -e "${RED}✗ GTX 1650 Audio not found!${NC}"
fi
echo ""

echo -e "${BLUE}=== 4. Driver Binding Check ===${NC}"
if lspci -nnk -s "$GTX1650_BUS" 2>/dev/null | grep -q "Kernel driver in use: vfio-pci"; then
    echo -e "${GREEN}✓ GTX 1650 GPU is bound to vfio-pci${NC}"
else
    echo -e "${RED}✗ GTX 1650 GPU is NOT bound to vfio-pci${NC}"
    echo "Current driver:"
    lspci -nnk -s "$GTX1650_BUS" 2>/dev/null | grep "Kernel driver"
fi

if lspci -nnk -s "$GTX1650_AUDIO_BUS" 2>/dev/null | grep -q "Kernel driver in use: vfio-pci"; then
    echo -e "${GREEN}✓ GTX 1650 Audio is bound to vfio-pci${NC}"
else
    echo -e "${RED}✗ GTX 1650 Audio is NOT bound to vfio-pci${NC}"
    echo "Current driver:"
    lspci -nnk -s "$GTX1650_AUDIO_BUS" 2>/dev/null | grep "Kernel driver"
fi
echo ""

echo -e "${BLUE}=== 5. IOMMU Groups ===${NC}"
if [ -n "$GTX1650_BUS" ]; then
    IOMMU_GROUP=$(basename $(dirname $(readlink /sys/bus/pci/devices/0000:$GTX1650_BUS/iommu_group)))
    echo "GTX 1650 IOMMU Group $IOMMU_GROUP:"
    for dev in /sys/kernel/iommu_groups/$IOMMU_GROUP/devices/*; do
        lspci -nns ${dev##*/}
    done
fi
echo ""

echo -e "${BLUE}=== 6. VFIO Device Nodes ===${NC}"
if [ -e /dev/vfio/vfio ]; then
    echo -e "${GREEN}✓ /dev/vfio/vfio exists${NC}"
    ls -la /dev/vfio/
else
    echo -e "${RED}✗ /dev/vfio/vfio missing${NC}"
fi
echo ""

echo -e "${BLUE}=== 7. All GPUs in System ===${NC}"
lspci | grep -i vga
echo ""
lspci | grep -i nvidia
echo ""

echo -e "${BLUE}=== 8. Libvirt VM Status ===${NC}"
if virsh list --all | grep -q "win10"; then
    echo -e "${GREEN}✓ VM 'win10' found${NC}"
    virsh dumpxml win10 | grep -A 5 "hostdev"
else
    echo -e "${YELLOW}⚠ VM 'win10' not found or not accessible${NC}"
fi
echo ""

echo "=========================================="
echo "SUMMARY"
echo "=========================================="

# Check overall status
PASS=0
TOTAL=6

[ -n "$GTX1650_BUS" ] && ((PASS++))
lsmod | grep -q vfio_pci && ((PASS++))
lspci -nnk -s "$GTX1650_BUS" 2>/dev/null | grep -q "vfio-pci" && ((PASS++))
lspci -nnk -s "$GTX1650_AUDIO_BUS" 2>/dev/null | grep -q "vfio-pci" && ((PASS++))
[ -e /dev/vfio/vfio ] && ((PASS++))
cat /proc/cmdline | grep -q "vfio-pci.ids" && ((PASS++))

echo "Passed: $PASS/$TOTAL checks"
if [ $PASS -eq $TOTAL ]; then
    echo -e "${GREEN}✓ GPU passthrough is properly configured!${NC}"
else
    echo -e "${YELLOW}⚠ Some issues found. Check the output above.${NC}"
fi
