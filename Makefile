setup:
	scripts/brew.sh
	scripts/code.sh
	scripts/link.sh
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

update:
	scripts/update.sh

.PHONY: setup brew code link mise zsh update
