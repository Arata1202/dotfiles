<div align="right">

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Arata1202/dotfiles/macos.yml)
![GitHub License](https://img.shields.io/github/license/Arata1202/dotfiles)

</div>

## Getting Started

### Install dotfiles on macOS

Install the Xcode Command Line Tools (`xcode-select --install`) and [Homebrew](https://brew.sh/). On Apple Silicon, load Homebrew in the current shell. The linked `.zprofile` will load it in future login shells.

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Clone into any permanent directory. The installed links point back to this checkout.

```bash
git clone https://github.com/Arata1202/dotfiles.git
cd dotfiles
make setup
```

Setup links the configuration and the Codex skills `ocr-review` (diffs) and `ocr-scan` (whole repositories), loads shared Git defaults before your personal settings, installs Homebrew packages and VS Code extensions, and sets Homebrew zsh as your login shell. Setup trusts the checkout’s `mise/config.toml` before installing its tools. The shell change may prompt for your password. If setup reports a link conflict, inspect the named file, move it aside if you want to use the repository version, and rerun setup.

To run a new review or scan, install the OpenCodeReview CLI (`ocr`) and configure an LLM provider for it.

Setup adds shared ignore patterns to Git’s default global ignore file (`$XDG_CONFIG_HOME/git/ignore`, or `~/.config/git/ignore`). Existing rules keep their order and take precedence over added defaults.

If you use `~/.zprofile.local` for machine-specific shell settings, copy it separately when moving to a new Mac.

### Package management

Use Homebrew for macOS applications, shell utilities, and native libraries used by other packages. OrbStack supplies the Docker CLI, Compose, and Buildx.

Use mise for language runtimes and development tools whose versions affect builds, generated files, or deployment workflows. `mise/config.toml` defines their default versions.

### Capture the current machine

Edit `homebrew/.Brewfile` and `vscode/extensions` to choose what setup installs. Run `make snapshot` to preview how the installed packages and extensions differ from these lists.

```bash
make snapshot
```

The Homebrew snapshot omits PHP and Composer because the mise PHP installation provides both commands. It also skips the legacy OpenSSL 1.1 formula. The extension snapshot omits dependencies and pack members installed by the listed extensions. For a partially installed extension-only pack, it lists the installed members individually.

To replace both lists with a fresh snapshot of the current machine, run `make snapshot-apply`.
