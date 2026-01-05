.PHONY: install format format-check help

help:
	@echo "Available commands:"
	@echo "  make install       - Install pre-commit and set up git hooks"
	@echo "  make format        - Format all markdown files with mdformat"
	@echo "  make format-check  - Check markdown formatting without modifying files"

install:
	@echo "Installing pre-commit..."
	pip install pre-commit mdformat mdformat-gfm mdformat-frontmatter
	@echo "Installing pre-commit hooks..."
	pre-commit install
	@echo "✓ Pre-commit hooks installed successfully"

format:
	@echo "Fixing end-of-file newlines and trailing whitespace..."
	pre-commit run end-of-file-fixer --all-files || true
	pre-commit run trailing-whitespace --all-files || true
	@echo "Formatting markdown files..."
	mdformat .

format-check:
	@echo "Checking markdown formatting..."
	mdformat --check .
