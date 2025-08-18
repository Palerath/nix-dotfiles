#!/bin/bash
set -e
echo "Rebuilding perikon..."
nh os switch '.' --hostname perikon
echo "✓ System rebuilt"
