all: brew link zsh

brew:
	.bin/brew.sh

link:
	.bin/link.sh

zsh:
	.bin/zsh.sh

.PHONY: all brew link zsh
