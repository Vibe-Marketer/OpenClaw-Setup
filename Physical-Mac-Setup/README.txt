PHYSICAL MAC SETUP
==================

FULL INSTALL (fresh Mac - installs everything)
----------------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Physical-Mac-Setup/install.sh)"


CONFIG ONLY (OpenClaw already installed)
----------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Physical-Mac-Setup/config-only.sh)"


WHAT YOU'LL BE ASKED
--------------------
1. Brave Search API Key - get at https://brave.com/search/api/
2. Gateway Password - secure password for your gateway
3. Phone Number - your number in +1XXXXXXXXXX format


AFTER RUNNING THE SCRIPT
------------------------
1. Set up Anthropic auth: claude setup-token
2. Open Tailscale from Applications and sign in
3. Grant Full Disk Access:
   System Settings > Privacy & Security > Full Disk Access
   Add: Terminal, /opt/homebrew/bin/imsg, /opt/homebrew/bin/node
4. Sign into Messages app with Apple ID
5. Restart gateway: openclaw gateway restart
