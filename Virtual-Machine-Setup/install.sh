#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Virtual Machine"
echo "===================================="
echo ""

# Install NVM
echo "[1/4] Installing NVM..."
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "       NVM already installed, skipping."
    source "$NVM_DIR/nvm.sh"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
fi

# Install Node.js via NVM
echo ""
echo "[2/4] Installing Node.js..."
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Install Claude Code CLI
echo ""
echo "[3/4] Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Install OpenClaw
echo ""
echo "[4/4] Installing OpenClaw..."
npm install -g openclaw

echo ""
echo "===================================="
echo "  OpenClaw is Ready!"
echo "===================================="
echo ""
echo "IMPORTANT: Close this Terminal window, then:"
echo ""
echo "  1. Open a NEW Terminal window"
echo "  2. Run: openclaw configure"
echo ""
echo "(The new terminal is needed to load the installed tools)"
echo ""

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "(Homebrew is already installed)"
else
    echo "===================================="
    echo "  Installing Homebrew in background"
    echo "===================================="
    echo ""
    echo "Homebrew will install in the background."
    echo "This includes Xcode tools and takes 10-30 minutes."
    echo "You can use OpenClaw now while that finishes."
    echo ""
    
    # Run Homebrew install in background (non-interactive for VMs)
    (NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile) &
    
    echo "Homebrew installing in background (PID: $!)"
fi
