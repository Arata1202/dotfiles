chmod:
	@chmod +x .bin/*.sh

all:
	.bin/brew.sh
	.bin/link.sh
	.bin/zsh.sh

brew:
	.bin/brew.sh

link:
	.bin/link.sh

zsh:
	.bin/zsh.sh

update:
	.bin/update.sh

.PHONY: chmod all brew link zsh update
