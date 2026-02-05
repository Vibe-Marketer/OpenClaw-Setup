PHYSICAL MAC SETUP
==================

FULL INSTALL (fresh Mac - installs everything)
----------------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Setup-Scripts/Physical-Mac-Setup/install.sh)"


CONFIG ONLY (OpenClaw already installed)
----------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Vibe-Marketer/OpenClaw-Setup/main/Setup-Scripts/Physical-Mac-Setup/config-only.sh)"


WHAT YOU'LL BE ASKED
--------------------
1. Brave Search API Key - get at https://brave.com/search/api/
2. Gateway Password - secure password for your gateway
3. Phone Number - your number in +1XXXXXXXXXX format
4. BlueBubbles setup (recommended) - or skip for legacy imsg


BLUEBUBBLES vs IMSG
-------------------
BlueBubbles (RECOMMENDED):
  - Better iMessage integration
  - Supports reactions, edit, unsend, effects
  - Install from: https://bluebubbles.app/install
  - Requires BlueBubbles server running on your Mac

Legacy imsg:
  - Simpler but fewer features
  - Requires Full Disk Access permissions
  - No additional server needed


AFTER RUNNING THE SCRIPT
------------------------
1. Set up Anthropic auth: claude setup-token
2. Open Tailscale from Applications and sign in
3. If using BlueBubbles:
   - Configure webhook: http://localhost:18789/bluebubbles-webhook
4. If using imsg:
   - Grant Full Disk Access (Terminal, imsg, node)
5. Sign into Messages app with Apple ID
6. Restart gateway: openclaw gateway restart
