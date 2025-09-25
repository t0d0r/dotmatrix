# Makefile for updating all Vim plugins/mods
# This will update all git repositories in the pack directory structure

.PHONY: help update status install clean

# Default target - show help
help:
	@echo "Vim Plugin/Mod Management Makefile"
	@echo "=================================="
	@echo ""
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  update   - Update all plugins, colors, and syntax mods"
	@echo "  status   - Show git status of all repositories"
	@echo "  install  - Install/reinstall all plugins from vim.submodules"
	@echo "  clean    - Remove all plugin directories (use with caution!)"
	@echo ""

# Update all mods (plugins, colors, syntax)
update:
	@echo "Updating all Vim plugins, colors, and syntax files..."
	@echo "====================================================="
	@echo ""
	@echo "Updating plugins..."
	@for dir in pack/plugins/start/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/.git" ]; then \
			echo "Updating $$dir"; \
			cd "$$dir" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || git pull 2>/dev/null || echo "Failed to update $$dir"; \
			cd - > /dev/null; \
		fi; \
	done
	@echo ""
	@echo "Updating color schemes..."
	@for dir in pack/colors/start/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/.git" ]; then \
			echo "Updating $$dir"; \
			cd "$$dir" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || git pull 2>/dev/null || echo "Failed to update $$dir"; \
			cd - > /dev/null; \
		fi; \
	done
	@echo ""
	@echo "Updating syntax files..."
	@for dir in pack/syntax/opt/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/.git" ]; then \
			echo "Updating $$dir"; \
			cd "$$dir" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || git pull 2>/dev/null || echo "Failed to update $$dir"; \
			cd - > /dev/null; \
		fi; \
	done
	@echo ""
	@echo "All updates completed!"

# Show status of all git repositories
status:
	@echo "Git status of all repositories:"
	@echo "==============================="
	@for dir in pack/plugins/start/*/ pack/colors/start/*/ pack/syntax/opt/*/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/.git" ]; then \
			echo ""; \
			echo "Status of $$dir:"; \
			cd "$$dir" && git status --porcelain && git log --oneline -1; \
			cd - > /dev/null; \
		fi; \
	done

# Install all plugins from vim.submodules file
install:
	@echo "Installing all plugins from vim.submodules..."
	@if [ -f "../vim.submodules" ]; then \
		cd .. && bash vim.submodules; \
	else \
		echo "vim.submodules file not found in parent directory"; \
		exit 1; \
	fi
