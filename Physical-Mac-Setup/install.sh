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
echo "  OpenClaw Installed!"
echo "===================================="
echo ""

# Copy openclaw configure to clipboard
echo "openclaw configure" | pbcopy
echo "Copied 'openclaw configure' to clipboard."
echo ""

# Open new Terminal window with openclaw configure ready to run
echo "Opening new Terminal window..."
osascript -e 'tell application "Terminal"
    do script "echo \"Paste and press Enter to configure OpenClaw:\" && echo \"(already copied to clipboard)\" && echo \"\""
    activate
end tell'

echo ""
echo "A new Terminal window opened."
echo "Just press Cmd+V and Enter to run 'openclaw configure'"
echo ""

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "(Homebrew already installed - skipping background install)"
else
    echo "===================================="
    echo "  Homebrew Installing in Background"
    echo "===================================="
    echo ""
    echo "Another Terminal window will install Homebrew + Tailscale + iMessage tools."
    echo "This takes 10-30 minutes but runs in the background."
    echo ""
    
    # Spawn new Terminal window for Homebrew + Tailscale + iMessage setup
    osascript -e 'tell application "Terminal"
        do script "echo \"\" && echo \"===================================\" && echo \"  Background Install\" && echo \"  Homebrew + Tailscale + iMessage\" && echo \"===================================\" && echo \"\" && echo \"[1/3] Installing Homebrew (this takes a while)...\" && /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && echo \"\" && echo \"Adding Homebrew to PATH...\" && echo '\''eval \"$(/opt/homebrew/bin/brew shellenv)\"'\'' >> ~/.zprofile && eval \"$(/opt/homebrew/bin/brew shellenv)\" && echo \"\" && echo \"[2/3] Installing Tailscale...\" && brew install --cask tailscale && echo \"\" && echo \"[3/3] Setting up iMessage tools...\" && brew install steipete/tap/imsg && mkdir -p ~/.openclaw && CURRENT_USER=$(whoami) && echo '\''{\"channels\":{\"imessage\":{\"enabled\":true,\"cliPath\":\"/opt/homebrew/bin/imsg\",\"dbPath\":\"/Users/'\"'$CURRENT_USER'\"'/Library/Messages/chat.db\",\"dmPolicy\":\"allowlist\",\"allowFrom\":[\"+1XXXXXXXXXX\"]}}}'\'' > ~/.openclaw/openclaw.json && echo \"\" && echo \"===================================\" && echo \"  Background Install Complete!\" && echo \"===================================\" && echo \"\" && echo \"NEXT STEPS:\" && echo \"\" && echo \"1. Open Tailscale from Applications and sign in\" && echo \"\" && echo \"2. Edit allowed phone numbers:\" && echo \"   nano ~/.openclaw/openclaw.json\" && echo \"   Change +1XXXXXXXXXX to real numbers\" && echo \"\" && echo \"3. Grant Full Disk Access:\" && echo \"   System Settings > Privacy & Security > Full Disk Access\" && echo \"   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node\" && echo \"\" && echo \"4. Sign into Messages app with Apple ID\" && echo \"\" && echo \"5. Start OpenClaw:\" && echo \"   openclaw gateway start\" && echo \"\""
        activate
    end tell'
fi

echo "===================================="
echo "  Setup Complete!"
echo "===================================="
echo ""
