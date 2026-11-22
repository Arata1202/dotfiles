setup:
	@command -v brew >/dev/null || { echo "Install Homebrew and add brew to PATH before setup." >&2; exit 1; }
	@command -v git >/dev/null || { echo "Install Git before setup." >&2; exit 1; }
	scripts/link.sh
	scripts/brew.sh
	scripts/code.sh
	scripts/mise.sh
	scripts/zsh.sh

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

update: snapshot

snapshot:
	scripts/update.sh

.PHONY: setup brew code link mise zsh update snapshot
