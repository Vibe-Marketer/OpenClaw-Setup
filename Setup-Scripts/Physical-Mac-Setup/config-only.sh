#!/bin/bash

# ============================================
# OpenClaw Config Only Script
# Run this if OpenClaw is already installed
# ============================================

echo "===================================="
echo "  OpenClaw Configuration"
echo "===================================="
echo ""

# Get current username for paths
CURRENT_USER=$(whoami)

# Collect configuration values
echo "I need a few things to configure OpenClaw."
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
    echo ""
    USE_BLUEBUBBLES=false
fi

# Create OpenClaw directories
echo "Creating OpenClaw configuration..."
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

echo ""
echo "===================================="
echo "  Config Created!"
echo "===================================="
echo ""
echo "Config saved to: ~/.openclaw/openclaw.json"
echo ""
echo "Next steps:"
echo "  1. Set up Anthropic auth: claude setup-token"
if [ "$USE_BLUEBUBBLES" = true ]; then
echo "  2. Configure BlueBubbles webhook: http://localhost:18789/bluebubbles-webhook"
else
echo "  2. Grant Full Disk Access for Terminal, imsg, and node"
fi
echo "  3. Start the gateway: openclaw gateway start"
echo ""
