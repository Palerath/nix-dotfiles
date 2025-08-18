#!/bin/bash
set -e
echo "Rebuilding linouce..."
nh os switch '.' --hostname linouce
echo "✓ System rebuilt"
