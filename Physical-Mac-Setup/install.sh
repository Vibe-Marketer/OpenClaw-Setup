#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Physical Mac"
echo "===================================="
echo ""

# Install Homebrew
echo "[1/4] Installing Homebrew..."
if command -v brew &> /dev/null; then
    echo "       Homebrew already installed, skipping."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Make sure brew is available
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install Node.js
echo ""
echo "[2/4] Installing Node.js..."
if command -v node &> /dev/null; then
    echo "       Node.js already installed, skipping."
else
    brew install node
fi

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
echo "  Installation Complete!"
echo "===================================="
echo ""
echo "Next step: Run this command:"
echo ""
echo "  openclaw configure"
echo ""
