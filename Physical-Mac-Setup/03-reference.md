# Reference (Physical Mac)

Useful paths and troubleshooting for OpenClaw on a physical Mac.

---

## Useful Paths

| Description | Path |
|-------------|------|
| OpenClaw config | `~/.openclaw/openclaw.json` |
| Messages database | `~/Library/Messages/chat.db` |
| imsg binary | `/opt/homebrew/bin/imsg` |
| Gateway logs | `/tmp/openclaw/openclaw-*.log` |

---

## Troubleshooting

### "command not found"

Your shell hasn't loaded the new PATH. Run:

```bash
source ~/.zprofile
```

Or restart your terminal.

---

### Permission errors during npm install

Use sudo:

```bash
sudo npm install -g openclaw
```

---

### imsg can't access Messages

Grant Full Disk Access in System Settings:

1. Open **System Settings**
2. Go to **Privacy & Security** > **Full Disk Access**
3. Add Terminal and `/opt/homebrew/bin/imsg`

---

### Gateway not starting

Check the logs:

```bash
tail -50 /tmp/openclaw/openclaw-*.log
```
