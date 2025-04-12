chmod:
	@chmod +x .bin/*.sh

all:
	.bin/brew.sh
	.bin/link.sh
	.bin/zsh.sh
	.bin/code.sh
	.bin/mise.sh

brew:
	.bin/brew.sh

link:
	.bin/link.sh

code:
	.bin/code.sh

zsh:
	.bin/zsh.sh

mise:
	.bin/mise.sh

update:
	.bin/update.sh

.PHONY: chmod all brew link code zsh mise update
