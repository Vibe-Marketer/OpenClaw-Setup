#!/bin/bash

echo "===================================="
echo "  iMessage + OpenClaw Setup"
echo "===================================="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "ERROR: Homebrew is not installed yet."
    echo ""
    echo "Please wait for Homebrew to finish installing in the other"
    echo "Terminal window, then run this script again."
    exit 1
fi

# Make sure brew is in PATH
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null

echo "[1/4] Installing imsg..."
brew install steipete/tap/imsg

echo ""
echo "[2/4] Testing imsg..."
imsg chats --limit 3 2>/dev/null || echo "       (Will work after Full Disk Access is granted)"

echo ""
echo "[3/4] Creating OpenClaw config..."

# Get the current username
CURRENT_USER=$(whoami)

# Create config directory if it doesn't exist
mkdir -p ~/.openclaw

# Create the config file
cat > ~/.openclaw/openclaw.json << EOF
{
    "channels": {
        "imessage": {
            "enabled": true,
            "cliPath": "/opt/homebrew/bin/imsg",
            "dbPath": "/Users/${CURRENT_USER}/Library/Messages/chat.db",
            "dmPolicy": "allowlist",
            "allowFrom": ["+1XXXXXXXXXX"]
        }
    }
}
EOF

echo "       Config created at ~/.openclaw/openclaw.json"
echo ""
echo "       IMPORTANT: Edit the config to add your allowed phone numbers:"
echo "       nano ~/.openclaw/openclaw.json"

echo ""
echo "===================================="
echo "  Manual Steps Required"
echo "===================================="
echo ""
echo "1. SIGN INTO iMESSAGE:"
echo "   - Open the Messages app"
echo "   - Sign in with your Apple ID"
echo "   - Verify with SMS if prompted"
echo ""
echo "2. GRANT FULL DISK ACCESS:"
echo "   - Open System Settings"
echo "   - Go to Privacy & Security > Full Disk Access"
echo "   - Add these (click + and press Cmd+Shift+G to enter path):"
echo "       /Applications/Utilities/Terminal.app"
echo "       /opt/homebrew/bin/imsg"
echo "       /opt/homebrew/bin/node"
echo ""
echo "3. EDIT ALLOWED PHONE NUMBERS:"
echo "   Run: nano ~/.openclaw/openclaw.json"
echo "   Change \"+1XXXXXXXXXX\" to actual phone numbers"
echo ""
echo "4. START OPENCLAW:"
echo "   openclaw gateway start"
echo "   openclaw status"
echo ""
