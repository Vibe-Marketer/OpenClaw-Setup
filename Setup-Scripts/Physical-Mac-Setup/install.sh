#!/bin/bash

echo "===================================="
echo "  OpenClaw Setup for Physical Mac"
echo "===================================="
echo ""

# Get current username for paths
CURRENT_USER=$(whoami)

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

# Collect configuration values
echo ""
echo "===================================="
echo "  Configuration Setup"
echo "===================================="
echo ""

# Brave Search API Key
echo "1. BRAVE SEARCH API KEY (for web search)"
echo "   Get yours at: https://brave.com/search/api/"
echo ""
read -p "   Enter your Brave Search API Key: " BRAVE_SEARCH_API_KEY
echo ""

# Gateway Password
echo "2. GATEWAY PASSWORD"
echo "   This secures access to your OpenClaw gateway."
echo ""
read -p "   Enter a secure password: " GATEWAY_PASSWORD
echo ""

# Phone Number for iMessage
echo "3. YOUR PHONE NUMBER (for iMessage allowlist)"
echo "   Format: +1XXXXXXXXXX (include country code)"
echo ""
read -p "   Enter your phone number: " PHONE_NUMBER
echo ""

# BlueBubbles setup
echo "4. BLUEBUBBLES SETUP (recommended for iMessage)"
echo "   BlueBubbles provides better iMessage integration."
echo "   Install from: https://bluebubbles.app/install"
echo ""
read -p "   Do you have BlueBubbles installed? (y/n): " HAS_BLUEBUBBLES
echo ""

if [[ "$HAS_BLUEBUBBLES" =~ ^[Yy]$ ]]; then
    echo "   Enter your BlueBubbles server details:"
    echo ""
    read -p "   Server URL (e.g., http://localhost:1234): " BLUEBUBBLES_URL
    read -p "   API Password (from BlueBubbles settings): " BLUEBUBBLES_PASSWORD
    echo ""
    USE_BLUEBUBBLES=true
else
    echo "   Skipping BlueBubbles - will use legacy imsg instead."
    echo "   You can set up BlueBubbles later if needed."
    echo ""
    USE_BLUEBUBBLES=false
fi

# Create OpenClaw directories
echo ""
echo "[5/5] Creating OpenClaw configuration..."
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.openclaw/credentials

# Create the config file based on BlueBubbles choice
if [ "$USE_BLUEBUBBLES" = true ]; then
    # Config with BlueBubbles (recommended)
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
    "bluebubbles": {
      "enabled": true,
      "serverUrl": "${BLUEBUBBLES_URL}",
      "password": "${BLUEBUBBLES_PASSWORD}",
      "webhookPath": "/bluebubbles-webhook",
      "dmPolicy": "allowlist",
      "allowFrom": [
        "${PHONE_NUMBER}"
      ],
      "groupPolicy": "allowlist",
      "groupAllowFrom": [
        "${PHONE_NUMBER}"
      ],
      "sendReadReceipts": true,
      "actions": {
        "reactions": true,
        "edit": true,
        "unsend": true,
        "reply": true,
        "sendWithEffect": true,
        "renameGroup": true,
        "addParticipant": true,
        "removeParticipant": true,
        "sendAttachment": true
      }
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
      "bluebubbles": {
        "enabled": true
      }
    }
  }
}
EOF
else
    # Config with legacy imsg
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
fi

echo "       Config created at ~/.openclaw/openclaw.json"

# Start the gateway
openclaw gateway start 2>/dev/null || true

echo ""
echo "===================================="
echo "  OpenClaw is Ready!"
echo "===================================="
echo ""
echo "Gateway is running on port 18789"
echo ""
echo "IMPORTANT: You still need to set up Anthropic auth separately."
echo "Run: claude setup-token"
echo ""
echo "Commands:"
echo "  openclaw dashboard      - Open web dashboard"
echo "  openclaw gateway status - Check gateway status"
echo "  openclaw agent          - Chat with the agent"
echo ""

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "(Homebrew already installed)"
    echo ""
    if [ "$USE_BLUEBUBBLES" = false ]; then
        echo "Installing iMessage tools..."
        brew install steipete/tap/imsg 2>/dev/null || true
    fi
    echo "Installing apps (Tailscale, Chrome, Chromium, Bitwarden)..."
    brew install --cask tailscale 2>/dev/null || true
    brew install --cask google-chrome 2>/dev/null || true
    brew install --cask chromium 2>/dev/null || true
    brew install --cask bitwarden 2>/dev/null || true
    echo ""
    echo "===================================="
    echo "  Manual Steps Required"
    echo "===================================="
    echo ""
    echo "1. Set up Anthropic auth: claude setup-token"
    echo ""
    echo "2. Open Tailscale from Applications and sign in"
    echo ""
    if [ "$USE_BLUEBUBBLES" = true ]; then
        echo "3. Configure BlueBubbles webhook:"
        echo "   Point to: http://localhost:18789/bluebubbles-webhook"
        echo ""
        echo "4. Sign into Messages app with Apple ID"
    else
        echo "3. Grant Full Disk Access:"
        echo "   System Settings > Privacy & Security > Full Disk Access"
        echo "   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node"
        echo ""
        echo "4. Sign into Messages app with Apple ID"
    fi
    echo ""
    echo "5. Restart the gateway:"
    echo "   openclaw gateway restart"
    echo ""
else
    echo "===================================="
    echo "  Homebrew Installing in Background"
    echo "===================================="
    echo ""
    echo "Another Terminal window will install Homebrew + Tailscale."
    echo "This takes 10-30 minutes but runs in the background."
    echo ""
    
    if [ "$USE_BLUEBUBBLES" = true ]; then
        # BlueBubbles - no imsg needed
        osascript <<EOF
tell application "Terminal"
    do script "echo '' && echo '===================================' && echo '  Background Install' && echo '  Homebrew + Apps' && echo '===================================' && echo '' && echo '[1/2] Installing Homebrew (this takes a while)...' && /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && echo '' && echo 'Adding Homebrew to PATH...' && echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile && eval \"\$(/opt/homebrew/bin/brew shellenv)\" && echo '' && echo '[2/2] Installing apps (Tailscale, Chrome, Chromium, Bitwarden)...' && (brew install --cask tailscale || true) && (brew install --cask google-chrome || true) && (brew install --cask chromium || true) && (brew install --cask bitwarden || true) && echo '' && echo '===================================' && echo '  Background Install Complete!' && echo '===================================' && echo '' && echo 'MANUAL STEPS REQUIRED:' && echo '' && echo '1. Set up Anthropic auth: claude setup-token' && echo '' && echo '2. Open Tailscale from Applications and sign in' && echo '' && echo '3. Configure BlueBubbles webhook:' && echo '   Point to: http://localhost:18789/bluebubbles-webhook' && echo '' && echo '4. Sign into Messages app with Apple ID' && echo '' && echo '5. Restart the gateway:' && echo '   openclaw gateway restart' && echo ''"
    activate
end tell
EOF
    else
        # Legacy imsg
        osascript <<EOF
tell application "Terminal"
    do script "echo '' && echo '===================================' && echo '  Background Install' && echo '  Homebrew + Apps + iMessage' && echo '===================================' && echo '' && echo '[1/3] Installing Homebrew (this takes a while)...' && /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" && echo '' && echo 'Adding Homebrew to PATH...' && echo 'eval \"\$(/opt/homebrew/bin/brew shellenv)\"' >> ~/.zprofile && eval \"\$(/opt/homebrew/bin/brew shellenv)\" && echo '' && echo '[2/3] Installing apps (Tailscale, Chrome, Chromium, Bitwarden)...' && (brew install --cask tailscale || true) && (brew install --cask google-chrome || true) && (brew install --cask chromium || true) && (brew install --cask bitwarden || true) && echo '' && echo '[3/3] Installing iMessage tools...' && brew install steipete/tap/imsg && echo '' && echo '===================================' && echo '  Background Install Complete!' && echo '===================================' && echo '' && echo 'MANUAL STEPS REQUIRED:' && echo '' && echo '1. Set up Anthropic auth: claude setup-token' && echo '' && echo '2. Open Tailscale from Applications and sign in' && echo '' && echo '3. Grant Full Disk Access:' && echo '   System Settings > Privacy & Security > Full Disk Access' && echo '   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node' && echo '' && echo '4. Sign into Messages app with Apple ID' && echo '' && echo '5. Restart the gateway:' && echo '   openclaw gateway restart' && echo ''"
    activate
end tell
EOF
    fi
fi

echo "===================================="
echo "  Setup Complete!"
echo "===================================="
echo ""
