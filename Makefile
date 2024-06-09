SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
POETRY = $(shell command -v poetry 2> /dev/null)
INSTALL_STAMP := .install.stamp
POETRY_STAMP := .poetry.stamp
GITHUB_PAGE := _site/index.html
.ONESHELL:

poetrysetup: $(POETRY_STAMP)
$(POETRY_STAMP):
	pipx install poetry
	poetry -V
	which poetry
	touch $(POETRY_STAMP)

deps: $(INSTALL_STAMP) poetrysetup
$(INSTALL_STAMP): pyproject.toml poetry.lock
	$(POETRY) install --sync
	touch $(INSTALL_STAMP)

pixify: pixyverse/dev/*.pix
	echo "Transpiling $?"
	$(POETRY) run python -m pixyverse.pixy -p $? -o $(@D)/$(basename $?).py


pages: $(GITHUB_PAGE)

$(GITHUB_PAGE): deps pixify
	mkdir -p _site
	cp -R static _site/
	$(POETRY) run python pixyverse/dev/__init__.py | tee _site/index.html


.PHONY: clean
clean:
	find . -type d -name "__pycache__" | xargs rm -rf {};
	rm -rf $(INSTALL_STAMP)
	rm -rf $(POETRY_STAMP)
	rm -rf _site
