# Install OpenClaw (Physical Mac)

Basic setup script for Homebrew, Node.js, Claude Code CLI, and OpenClaw on a physical Mac.

## Instructions

1. Open Terminal
2. Copy the entire script below
3. Paste and press Enter

## Script

```bash
#!/bin/bash

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Adding Homebrew to PATH..."
if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing Node.js..."
brew install node

echo "Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

echo "Installing OpenClaw..."
npm install -g openclaw

echo ""
echo "Installation complete!"
echo "Next step: openclaw configure"
```

## What This Installs

- **Homebrew** - Package manager for macOS
- **Node.js** - JavaScript runtime (via Homebrew)
- **Claude Code CLI** - Anthropic's CLI tool
- **OpenClaw** - OpenClaw gateway

## Next Steps

After running this script:

```bash
openclaw configure
```

If you want iMessage integration, continue to **02-imessage-setup.md**.
