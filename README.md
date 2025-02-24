# dotfiles
Dotfiles, maintained by chezmoi.

## Bitwarden
This repo features a sanity-check script that runs before any `sync` operation and performs the following checks:
*  Confirms that the Bitwarden CLI is installed
*  Confirms that the `BW_SESSION` environment variable has been set

## Other scripts
The `run_once_before_apply.sh.tmpl` script installs prerequisite apt, pip, and snap components that are defined in `.chezmoidata/packages.yaml` so things like zsh plugins will work correctly.
