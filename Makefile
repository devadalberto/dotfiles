STOW_DIR := $(shell pwd)
STOW_TARGET := $(HOME)
STOW := stow --dir=$(STOW_DIR) --target=$(STOW_TARGET) --verbose=1
PACKAGES := bash zsh tmux claude bin
.PHONY: all install unstow restow update-claude help
all: install
install:
	@for pkg in $(PACKAGES); do \
		echo "stowing $$pkg"; \
		$(STOW) $$pkg 2>&1 | grep -v "^stow: " || true; \
	done
	@echo "dotfiles installed"
unstow:
	@for pkg in $(PACKAGES); do \
		echo "unstowing $$pkg"; \
		$(STOW) -D $$pkg 2>&1 | grep -v "^stow: " || true; \
	done
restow:
	@for pkg in $(PACKAGES); do \
		echo "restowing $$pkg"; \
		$(STOW) -R $$pkg 2>&1 | grep -v "^stow: " || true; \
	done
update-claude:
	git subtree pull --prefix claude/.claude/agents \
		https://github.com/msitarzewski/agency-agents main --squash
	git subtree pull --prefix claude/.claude/skills/impeccable \
		https://github.com/pbakaus/impeccable main --squash
	git subtree pull --prefix claude/.claude/skills/autoresearch \
		https://github.com/uditgoenka/autoresearch master --squash
	git subtree pull --prefix claude/.claude/skills/lightpanda \
		https://github.com/lightpanda-io/agent-skill main --squash
help:
	@echo "make install        stow all packages"
	@echo "make unstow         remove all symlinks"
	@echo "make restow         re-link all packages"
	@echo "make update-claude  pull latest agents + skills"
