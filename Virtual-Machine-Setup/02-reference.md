# Reference (Virtual Machine)

Useful paths and troubleshooting for OpenClaw on a virtual machine.

---

## Useful Paths

| Description | Path |
|-------------|------|
| OpenClaw config | `~/.openclaw/openclaw.json` |
| NVM directory | `~/.nvm` |
| Gateway logs | `/tmp/openclaw/openclaw-*.log` |

---

## Troubleshooting

### "command not found: brew"

Your shell hasn't loaded the Homebrew PATH. Run:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Or add it permanently:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

---

### "command not found: node" or "command not found: npm"

NVM isn't loaded in your current shell. Run:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
```

---

### Permission errors during npm install

Use sudo:

```bash
sudo npm install -g openclaw
```

---

### Gateway not starting

Check the logs:

```bash
tail -50 /tmp/openclaw/openclaw-*.log
```

---

## Note on iMessage

iMessage integration is **not available** on virtual machines. It requires a physical Mac with an Apple ID signed in.
