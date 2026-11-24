.NOTPARALLEL:

setup: check-tools link brew code mise zsh

check-tools:
	@command -v brew >/dev/null || { echo "Install Homebrew and add brew to PATH before setup." >&2; exit 1; }
	@command -v git >/dev/null || { echo "Install Git before setup." >&2; exit 1; }

brew:
	scripts/brew.sh

code:
	scripts/code.sh

link:
	scripts/link.sh

mise:
	scripts/mise.sh

zsh:
	scripts/zsh.sh

snapshot:
	scripts/snapshot.sh

snapshot-apply:
	scripts/snapshot.sh --apply

.PHONY: setup check-tools brew code link mise zsh snapshot snapshot-apply
