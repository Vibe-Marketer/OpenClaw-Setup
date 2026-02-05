#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Physical Mac"
echo "===================================="
echo ""

# Get current username for paths
CURRENT_USER=$(whoami)

# Install NVM
echo "[1/6] Installing NVM..."
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
echo "[2/6] Installing Node.js..."
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Install Claude Code CLI
echo ""
echo "[3/6] Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Install OpenClaw
echo ""
echo "[4/6] Installing OpenClaw..."
npm install -g openclaw

# Collect configuration values
echo ""
echo "===================================="
echo "  Configuration Setup"
echo "===================================="
echo ""
echo "I need a few things to set up OpenClaw for you."
echo ""

# Anthropic API Key
echo "1. ANTHROPIC API KEY"
echo "   Get yours at: https://console.anthropic.com/settings/keys"
echo ""
read -p "   Enter your Anthropic API Key: " ANTHROPIC_API_KEY
echo ""

# Brave Search API Key
echo "2. BRAVE SEARCH API KEY (for web search)"
echo "   Get yours at: https://brave.com/search/api/"
echo ""
read -p "   Enter your Brave Search API Key: " BRAVE_SEARCH_API_KEY
echo ""

# Gateway Password
echo "3. GATEWAY PASSWORD"
echo "   This secures access to your OpenClaw gateway."
echo ""
read -p "   Enter a secure password: " GATEWAY_PASSWORD
echo ""

# Phone Number for iMessage
echo "4. YOUR PHONE NUMBER (for iMessage allowlist)"
echo "   Format: +1XXXXXXXXXX (include country code)"
echo ""
read -p "   Enter your phone number: " PHONE_NUMBER
echo ""

# Create OpenClaw directories
echo ""
echo "[5/6] Creating OpenClaw configuration..."
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.openclaw/credentials

# Store Anthropic API key
echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\"" >> ~/.zprofile
export ANTHROPIC_API_KEY

# Create the full config file
cat > ~/.openclaw/openclaw.json << EOF
{
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "token"
      }
    }
  },
  "agents": {
    "defaults": {
      "models": {
        "anthropic/claude-opus-4-5": {
          "alias": "opus"
        }
      },
      "workspace": "/Users/${CURRENT_USER}/.openclaw/workspace",
      "contextPruning": {
        "mode": "cache-ttl",
        "ttl": "1h"
      },
      "compaction": {
        "mode": "safeguard"
      },
      "heartbeat": {
        "every": "1h"
      },
      "maxConcurrent": 4,
      "subagents": {
        "maxConcurrent": 8
      }
    }
  },
  "tools": {
    "web": {
      "search": {
        "enabled": true,
        "apiKey": "${BRAVE_SEARCH_API_KEY}"
      },
      "fetch": {
        "enabled": true
      }
    }
  },
  "messages": {
    "ackReactionScope": "group-mentions"
  },
  "commands": {
    "native": "auto",
    "nativeSkills": "auto"
  },
  "session": {
    "dmScope": "per-channel-peer"
  },
  "channels": {
    "imessage": {
      "enabled": true,
      "cliPath": "/opt/homebrew/bin/imsg",
      "dbPath": "/Users/${CURRENT_USER}/Library/Messages/chat.db",
      "dmPolicy": "allowlist",
      "allowFrom": [
        "${PHONE_NUMBER}"
      ],
      "groupAllowFrom": [
        "${PHONE_NUMBER}"
      ],
      "groupPolicy": "allowlist"
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "password",
      "password": "${GATEWAY_PASSWORD}",
      "allowTailscale": true
    },
    "tailscale": {
      "mode": "serve",
      "resetOnExit": true
    }
  },
  "plugins": {
    "entries": {
      "imessage": {
        "enabled": true
      }
    }
  }
}
EOF

echo "       Config created at ~/.openclaw/openclaw.json"

# Install and start the daemon
echo ""
echo "[6/6] Installing OpenClaw daemon..."
openclaw onboard --non-interactive \
    --mode local \
    --auth-choice apiKey \
    --anthropic-api-key "$ANTHROPIC_API_KEY" \
    --gateway-port 18789 \
    --gateway-bind loopback \
    --install-daemon \
    --daemon-runtime node \
    --skip-skills 2>/dev/null || true

# Start the gateway
openclaw gateway start 2>/dev/null || true

echo ""
echo "===================================="
echo "  OpenClaw is Ready!"
echo "===================================="
echo ""
echo "Gateway is running on port 18789"
echo ""
echo "Commands:"
echo "  openclaw dashboard    - Open web dashboard"
echo "  openclaw gateway status - Check gateway status"
echo "  openclaw agent        - Chat with the agent"
echo ""

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "(Homebrew already installed)"
    echo ""
    echo "Installing iMessage tools..."
    brew install steipete/tap/imsg 2>/dev/null || true
    brew install --cask tailscale 2>/dev/null || true
    echo ""
    echo "===================================="
    echo "  Manual Steps Required"
    echo "===================================="
    echo ""
    echo "1. Open Tailscale from Applications and sign in"
    echo ""
    echo "2. Grant Full Disk Access:"
    echo "   System Settings > Privacy & Security > Full Disk Access"
    echo "   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node"
    echo ""
    echo "3. Sign into Messages app with Apple ID"
    echo ""
    echo "4. Restart the gateway:"
    echo "   openclaw gateway restart"
    echo ""
else
    echo "===================================="
    echo "  Homebrew Installing in Background"
    echo "===================================="
    echo ""
    echo "Another Terminal window will install Homebrew + Tailscale + iMessage tools."
    echo "This takes 10-30 minutes but runs in the background."
    echo ""
    
    # Spawn new Terminal window for Homebrew + Tailscale + iMessage setup
    osascript <<EOF
tell application "Terminal"
    do script "echo '' && echo '===================================' && echo '  Background Install' && echo '  Homebrew + Tailscale + iMessage' && echo '===================================' && echo '' && echo '[1/3] Installing Homebrew (this takes a while)...' && /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && echo '' && echo 'Adding Homebrew to PATH...' && echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile && eval \"\$(/opt/homebrew/bin/brew shellenv)\" && echo '' && echo '[2/3] Installing Tailscale...' && brew install --cask tailscale && echo '' && echo '[3/3] Installing iMessage tools...' && brew install steipete/tap/imsg && echo '' && echo '===================================' && echo '  Background Install Complete!' && echo '===================================' && echo '' && echo 'MANUAL STEPS REQUIRED:' && echo '' && echo '1. Open Tailscale from Applications and sign in' && echo '' && echo '2. Grant Full Disk Access:' && echo '   System Settings > Privacy & Security > Full Disk Access' && echo '   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node' && echo '' && echo '3. Sign into Messages app with Apple ID' && echo '' && echo '4. Restart the gateway:' && echo '   openclaw gateway restart' && echo ''"
    activate
end tell
EOF
fi

echo "===================================="
echo "  Setup Complete!"
echo "===================================="
echo ""
