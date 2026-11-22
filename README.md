<div align="right">

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Arata1202/dotfiles/macos.yml)
![GitHub License](https://img.shields.io/github/license/Arata1202/dotfiles)

</div>

## Getting Started

### Install dotfiles on macOS

Install the Xcode Command Line Tools (`xcode-select --install`) and [Homebrew](https://brew.sh/). Follow Homebrew's shell setup instructions and confirm that `git`, `make`, and `brew` are on your PATH.

Clone into any permanent directory. The installed links point back to this checkout.

```bash
git clone https://github.com/Arata1202/dotfiles.git
cd dotfiles
make setup
```

Setup links the configuration, loads shared Git defaults before your personal settings, installs Homebrew packages and VS Code extensions, and sets Homebrew zsh as your login shell. Setup trusts the checkout’s `mise/config.toml` before installing its tools. The shell change may prompt for your password. If setup reports a link conflict, inspect the named file, move it aside if you want to use the repository version, and rerun setup.

### Capture the current machine

Edit `homebrew/.Brewfile` and `vscode/extensions` to choose what setup installs. Run `make snapshot` (or `make update`) to preview how the installed packages and extensions differ from these lists.

```bash
make snapshot
```

To replace both lists with a fresh snapshot of the current machine, run `make snapshot-apply`.
