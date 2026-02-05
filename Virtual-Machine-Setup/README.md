# Virtual Machine Setup

Use this script when setting up OpenClaw on a **virtual machine** (cloud VM, local VM, automated provisioning, etc.).

## Files

| Order | File | Description |
|-------|------|-------------|
| 1 | [01-provision-vm.md](01-provision-vm.md) | Full automated setup script |
| 2 | [02-reference.md](02-reference.md) | Useful paths and troubleshooting |

## Quick Start

1. Run the script in **01-provision-vm.md**
2. Run `openclaw configure` when prompted
3. Refer to **02-reference.md** for paths and troubleshooting

## Notes

- This script runs non-interactively (no prompts)
- Uses NVM for Node.js version management
- Installs additional developer tools (git, gh, jq, curl, wget)
- iMessage integration is **not available** on virtual machines
