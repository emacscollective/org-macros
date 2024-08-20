-include config.mk

ifndef PKGS
PKGS  = borg
PKGS += epkg
PKGS += forge
PKGS += ghub
PKGS += magit
PKGS += with-editor
PKGS += transient
endif

ROOT ?= ~/.config/emacs/lib/
DEST ?= /docs/.orgconfig
DIRS := $(addprefix $(ROOT),$(addsuffix $(DEST),$(PKGS)))

help:
	$(info make spread       - copy orgconfig to all packages)
	@printf "\n"

spread:
	@for dest in $(DIRS); do cp -v orgconfig $$dest; done
