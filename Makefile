chmod:
	@chmod +x .bin/*.sh

all:
	brew link zsh

brew:
	.bin/brew.sh

link:
	.bin/link.sh

zsh:
	.bin/zsh.sh

update:
	.bin/update.sh

.PHONY: chmod all brew link zsh update
