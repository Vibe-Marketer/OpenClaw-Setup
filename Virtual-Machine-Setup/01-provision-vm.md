# Provision VM

Full automated setup script for virtual machines. Runs non-interactively and includes NVM for Node.js version management.

## Instructions

1. Open Terminal or SSH into your VM
2. Copy the entire script below
3. Paste and press Enter
4. Wait for completion, then run `openclaw configure`

## Script

```bash
#!/bin/bash

set -e

log_info() { echo "[INFO] $1"; }
log_success() { echo "[SUCCESS] $1"; }

install_homebrew() {
    log_info "Installing Homebrew..."
    if command -v brew &> /dev/null; then
        log_success "Homebrew already installed"
        return 0
    fi
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log_success "Homebrew installed"
}

install_nvm() {
    log_info "Installing NVM..."
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        log_success "NVM already installed"
        source "$NVM_DIR/nvm.sh"
        return 0
    fi
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    log_success "NVM installed"
}

install_nodejs() {
    log_info "Installing Node.js via NVM..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    log_success "Node.js installed: $(node --version)"
}

install_claude() {
    log_info "Installing Claude Code CLI..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code CLI installed"
}

install_openclaw() {
    log_info "Installing OpenClaw..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    npm install -g openclaw
    log_success "OpenClaw installed"
}

install_extras() {
    log_info "Installing additional tools..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew install git gh jq curl wget || true
    log_success "Additional tools installed"
}

main() {
    install_homebrew
    install_nvm
    install_nodejs
    install_claude
    install_openclaw
    install_extras
    echo ""
    echo "Done! Next: openclaw configure"
}

main "$@"
```

## What This Installs

- **Homebrew** - Package manager for macOS
- **NVM** - Node Version Manager for managing Node.js versions
- **Node.js LTS** - Latest long-term support version
- **Claude Code CLI** - Anthropic's CLI tool
- **OpenClaw** - OpenClaw gateway
- **Extra tools** - git, gh (GitHub CLI), jq, curl, wget

## Next Steps

After the script completes:

```bash
openclaw configure
```
