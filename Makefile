chmod:
	@chmod +x .bin/*.sh

all:
	.bin/brew.sh
	.bin/link.sh
	.bin/zsh.sh
	.bin/code.sh

brew:
	.bin/brew.sh

link:
	.bin/link.sh

code:
	.bin/code.sh

zsh:
	.bin/zsh.sh

update:
	.bin/update.sh

.PHONY: chmod all brew link code zsh update
