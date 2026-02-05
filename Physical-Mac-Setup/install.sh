#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Physical Mac"
echo "===================================="
echo ""

# Install NVM
echo "[1/5] Installing NVM..."
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
echo "[2/5] Installing Node.js..."
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Install Claude Code CLI
echo ""
echo "[3/5] Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Install OpenClaw
echo ""
echo "[4/5] Installing OpenClaw..."
npm install -g openclaw

# Prompt for Anthropic API Key
echo ""
echo "===================================="
echo "  Anthropic API Key Required"
echo "===================================="
echo ""
echo "Get your API key from: https://console.anthropic.com/settings/keys"
echo ""
read -p "Enter your Anthropic API Key: " ANTHROPIC_API_KEY
echo ""

if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "No API key provided. You'll need to run 'openclaw onboard' manually later."
    SKIP_ONBOARD=true
else
    SKIP_ONBOARD=false
fi

# Run OpenClaw onboard automatically
echo ""
echo "[5/5] Configuring OpenClaw..."

if [ "$SKIP_ONBOARD" = false ]; then
    # Store API key in environment for this session and future shells
    echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\"" >> ~/.zprofile
    export ANTHROPIC_API_KEY
    
    # Run non-interactive onboard with Anthropic API key
    openclaw onboard --non-interactive \
        --mode local \
        --auth-choice apiKey \
        --anthropic-api-key "$ANTHROPIC_API_KEY" \
        --gateway-port 18789 \
        --gateway-bind loopback \
        --install-daemon \
        --daemon-runtime node
    
    echo ""
    echo "OpenClaw configured with Anthropic!"
fi

echo ""
echo "===================================="
echo "  OpenClaw is Ready!"
echo "===================================="
echo ""
echo "The gateway daemon is now running."
echo ""
echo "Open the dashboard: openclaw dashboard"
echo "Check status:       openclaw gateway status"
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
    
    # Get current username for the config
    CURRENT_USER=$(whoami)
    
    # Spawn new Terminal window for Homebrew + Tailscale + iMessage setup
    osascript <<EOF
tell application "Terminal"
    do script "echo '' && echo '===================================' && echo '  Background Install' && echo '  Homebrew + Tailscale + iMessage' && echo '===================================' && echo '' && echo '[1/3] Installing Homebrew (this takes a while)...' && /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && echo '' && echo 'Adding Homebrew to PATH...' && echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile && eval \"\$(/opt/homebrew/bin/brew shellenv)\" && echo '' && echo '[2/3] Installing Tailscale...' && brew install --cask tailscale && echo '' && echo '[3/3] Setting up iMessage tools...' && brew install steipete/tap/imsg && echo '' && echo 'Updating OpenClaw config with iMessage...' && openclaw config set channels.imessage.enabled true && openclaw config set channels.imessage.cliPath /opt/homebrew/bin/imsg && openclaw config set channels.imessage.dbPath /Users/${CURRENT_USER}/Library/Messages/chat.db && openclaw config set channels.imessage.dmPolicy allowlist && echo '' && echo '===================================' && echo '  Background Install Complete!' && echo '===================================' && echo '' && echo 'NEXT STEPS:' && echo '' && echo '1. Open Tailscale from Applications and sign in' && echo '' && echo '2. Edit allowed phone numbers:' && echo '   openclaw config set channels.imessage.allowFrom \\\"[\\\\\\\"+1XXXXXXXXXX\\\\\\\"]\\\"' && echo '   (Replace +1XXXXXXXXXX with real phone numbers)' && echo '' && echo '3. Grant Full Disk Access:' && echo '   System Settings > Privacy & Security > Full Disk Access' && echo '   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node' && echo '' && echo '4. Sign into Messages app with Apple ID' && echo '' && echo '5. Restart the gateway:' && echo '   openclaw gateway restart' && echo ''"
    activate
end tell
EOF
fi

echo "===================================="
echo "  Setup Complete!"
echo "===================================="
echo ""
