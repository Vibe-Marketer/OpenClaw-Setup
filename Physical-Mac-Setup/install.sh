#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Physical Mac"
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
    echo "A new Terminal window will open to install Homebrew + Tailscale."
    echo "This includes Xcode tools and takes 10-30 minutes."
    echo "You can use OpenClaw now while that finishes."
    echo ""
    
    # Spawn new Terminal window for Homebrew + Tailscale install
    osascript -e 'tell application "Terminal"
        do script "echo \"===================================\" && echo \"  Installing Homebrew + Tailscale\" && echo \"===================================\" && echo \"\" && echo \"[1/2] Installing Homebrew...\" && /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && eval \"$(/opt/homebrew/bin/brew shellenv)\" && echo \"\" && echo \"[2/2] Installing Tailscale...\" && brew install --cask tailscale && echo \"\" && echo \"===================================\" && echo \"  Done!\" && echo \"===================================\" && echo \"\" && echo \"Open Tailscale from Applications and sign in.\" && echo \"\" && echo \"For iMessage setup, run this in a new terminal:\" && echo \"/bin/bash -c \\\"\\$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Physical-Mac-Setup/setup-imessage.sh)\\\"\" && echo \"\" && echo \"You can close this window.\""
        activate
    end tell'
fi

echo ""
echo "===================================="
echo "  For iMessage Setup (after Homebrew finishes)"
echo "===================================="
echo ""
echo "Run this command in a new terminal:"
echo ""
echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Physical-Mac-Setup/setup-imessage.sh)\""
echo ""
