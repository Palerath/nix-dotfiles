#!/usr/bin/env bash
# GPU Passthrough Status Checker

echo "=== GPU Device Information ==="
lspci -nnk | grep -A 3 -E "(VGA|3D)"

echo -e "\n=== VFIO Device Binding ==="
for dev in /sys/bus/pci/drivers/vfio-pci/*; do
    if [[ -e "$dev" && "$dev" != *module* ]]; then
        echo "$(basename $dev): $(lspci -s $(basename $dev))"
    fi
done

echo -e "\n=== NVIDIA Driver Binding ==="
for dev in /sys/bus/pci/drivers/nvidia/*; do
    if [[ -e "$dev" && "$dev" != *module* && "$dev" != *unbind* && "$dev" != *bind* ]]; then
        echo "$(basename $dev): $(lspci -s $(basename $dev))"
    fi
done

echo -e "\n=== GPU Power States ==="
for gpu in /sys/class/drm/card*/device; do
    if [[ -e "$gpu/power/control" ]]; then
        echo "$(basename $(dirname $(dirname $gpu))):"
        echo "  Control: $(cat $gpu/power/control)"
        echo "  Runtime Status: $(cat $gpu/power/runtime_status 2>/dev/null || echo 'N/A')"
        echo "  Runtime Suspended Time: $(cat $gpu/power/runtime_suspended_time 2>/dev/null || echo 'N/A')ms"
    fi
done

echo -e "\n=== IOMMU Groups ==="
shopt -s nullglob
for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d#*/iommu_groups/*}
    n=${n%%/*}
    printf 'IOMMU Group %s: %s\n' "$n" "$(lspci -nns ${d##*/})"
done | sort -V

echo -e "\n=== VM-Ready Check ==="
if lsmod | grep -q vfio_pci; then
    echo "✓ vfio-pci module loaded"
else
    echo "✗ vfio-pci module NOT loaded"
fi

if [[ -e /dev/vfio/vfio ]]; then
    echo "✓ VFIO device exists"
else
    echo "✗ VFIO device missing"
fi

# Check if GTX 1650 is bound to vfio-pci
if lspci -nnk | grep -A 3 "1f82" | grep -q "vfio-pci"; then
    echo "✓ GTX 1650 bound to vfio-pci"
else
    echo "✗ GTX 1650 NOT bound to vfio-pci"
fi

# Check if RTX 3060 is bound to nvidia
if lspci -nnk | grep -A 3 "2184" | grep -q "nvidia"; then
    echo "✓ RTX 3060 bound to nvidia driver"
else
    echo "✗ RTX 3060 NOT bound to nvidia driver"
fi
