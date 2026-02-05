# iMessage Setup (Physical Mac Only)

Configure OpenClaw to work with iMessage. This only works on physical Macs (not virtual machines).

**Prerequisite:** Complete **01-install-openclaw.md** first.

---

## Step 1: Sign Into iMessage

1. Open the **Messages** app
2. Sign in with your Apple ID
3. Verify with SMS if prompted

---

## Step 2: Install imsg

```bash
brew install steipete/tap/imsg
imsg chats --limit 3
```

---

## Step 3: Edit Configuration

Open the config file:

```bash
nano ~/.openclaw/openclaw.json
```

Add/update the iMessage channel configuration:

```json
{
    "channels": {
        "imessage": {
            "enabled": true,
            "cliPath": "/opt/homebrew/bin/imsg",
            "dbPath": "/Users/USERNAME/Library/Messages/chat.db",
            "dmPolicy": "allowlist",
            "allowFrom": ["+1XXXXXXXXXX"]
        }
    }
}
```

**Important:** Replace `USERNAME` with your macOS username and `+1XXXXXXXXXX` with allowed phone numbers.

---

## Step 4: Grant Full Disk Access

1. Open **System Settings**
2. Go to **Privacy & Security** > **Full Disk Access**
3. Add the following:
   - Terminal
   - `/opt/homebrew/bin/imsg`
   - `/opt/homebrew/bin/node`

---

## Step 5: Start OpenClaw

```bash
openclaw gateway start
openclaw status
```
