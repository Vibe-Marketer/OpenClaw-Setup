#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Virtual Machine"
echo "===================================="
echo ""

# Install Homebrew (non-interactive)
echo "[1/5] Installing Homebrew..."
if command -v brew &> /dev/null; then
    echo "       Homebrew already installed, skipping."
else
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure brew is available
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null

# Install NVM
echo ""
echo "[2/5] Installing NVM..."
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
echo "[3/5] Installing Node.js..."
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Install Claude Code CLI
echo ""
echo "[4/5] Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Install OpenClaw
echo ""
echo "[5/5] Installing OpenClaw..."
npm install -g openclaw

# Install extra tools
echo ""
echo "[Bonus] Installing extra tools (git, gh, jq, curl, wget)..."
brew install git gh jq curl wget 2>/dev/null || true

echo ""
echo "===================================="
echo "  Installation Complete!"
echo "===================================="
echo ""
echo "Next step: Run this command:"
echo ""
echo "  openclaw configure"
echo ""
