SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
POETRY = $(shell command -v poetry 2> /dev/null)

pixify: pixyverse/dev/*.pix
	echo "Transpiling $?"
	$(POETRY) run python -m pixyverse.pixy -p $? -o $(@D)/$(basename $?).py


assemble:
	mkdir -p build
	cp -R static build/
	$(POETRY) run python pixyverse/dev/__init__.py | tee build/index.html