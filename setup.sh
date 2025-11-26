#!/bin/bash
set -e

# Variables
SRCPATH="$HOME/parsec-benchmark"

# List of programs that can be compiled with clang and c++17
programs=(
    blacksholes
    bodytrack
    ferret
    fluidanimate
    freqmine
    swaptions
    x264
    vips
)

# Install all dependencies
sudo apt install build-essential autoconf automake libtool pkg-config libffi-dev libpcre3-dev libglib2.0-dev gettext libomp-dev

# Clone the repo (if not already present)
if [ ! -d "$SRCPATH" ]; then
  cd $HOME
  git clone https://github.com/thekevalian/parsec-benchmark-clang.git "$SRCPATH"
fi

cd "$SRCPATH"

# Add parsec-bin tools to PATH
export PATH="$PATH:$SRCPATH/bin"

# Configure PARSEC
./configure

# Source the environment (this sets up parsecmgmt)
. ./env.sh

# Build with clang (not all benchmarks due to c++17 standard issues with register keyword)

for p in "${programs[@]}"; do
    echo "Building $p..."
    parsecmgmt -a build -p "$p"
done

# failed benchmarks
# facesim - could not compile to do some template errors
# raytrace - way to many register keywords to remove for clang