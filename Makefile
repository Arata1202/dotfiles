setup:
	.bin/brew.sh
	.bin/code.sh
	.bin/link.sh
	.bin/mise.sh
	.bin/zsh.sh

brew:
	.bin/brew.sh

code:
	.bin/code.sh

link:
	.bin/link.sh

mise:
	.bin/mise.sh

zsh:
	.bin/zsh.sh

update:
	.bin/update.sh

.PHONY: setup brew code link mise zsh update
