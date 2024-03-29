NAME := manu_sdk
INSTALL_STAMP := .install.stamp
POETRY := $(shell command -v poetry 2> /dev/null)
TEST := tests
.DEFAULT_GOAL := help

.SILENT:
.PHONY: help
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo ""
	@echo "  install-poetry       install poetry if not already installed"
	@echo "  install              install packages and prepare environment"
	@echo "  clean                remove all temporary files"
	@echo "  lint                 run the code linters"
	@echo "  type-check           type check the code with mypy"
	@echo "  format               reformat code"
	@echo "  test                 run all the tests"
	@echo "  build                run linters, tests and build package"
	@echo "  psr-bump             Bumps version and builds changelog locally"
	@echo "  psr-publish          Bumps version and builds changelog and push to git"
	@echo ""
	@echo "Check the Makefile to know exactly what each target is doing."

install: $(INSTALL_STAMP)
$(INSTALL_STAMP): pyproject.toml poetry.lock
	@if [ -z $(POETRY) ]; then echo "Poetry could not be found. See https://python-poetry.org/docs/"; exit 2; fi
	@echo "poetry install --with=dev" 
	$(POETRY) install --with=dev
	touch $(INSTALL_STAMP)

.PHONY: install-poetry
install-poetry:  ## Installs poetry.
ifeq ($(strip $(POETRY)),)
	@echo "Installing Poetry..." 
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
	pipx install poetry
endif

.PHONY: clean
clean:
	@echo "Cleaning..." 
	find . -type d -name "__pycache__" | xargs rm -rf {};
	rm -rf $(INSTALL_STAMP) .mypy_cache .pytest_cache dist

.PHONY: lint
lint: $(INSTALL_STAMP)
	@echo "Running Flake8..." 
	$(POETRY) run flake8 $(TEST) $(NAME)
	# @echo "Running RST-LINT..." 
	# $(POETRY) run rst-lint ./docs

.PHONY: type-check
type-check: $(INSTALL_STAMP)
	@echo "Running MYPY..." 
	$(POETRY) run mypy $(TEST) $(NAME) --ignore-missing-imports

.PHONY: format
format: $(INSTALL_STAMP)
	@echo "Formatting Code..." 
	$(POETRY) run isort --profile=black --lines-after-imports=2 $(TEST) $(NAME)
	$(POETRY) run black $(TEST) $(NAME)

.PHONY: test
test: $(INSTALL_STAMP)
	@echo "Running Pytests..." 
	$(POETRY) run pytest $(TEST) --disable-warnings

.PHONY: build
build: clean install lint test
	@echo "Building Package..." 
	$(POETRY) build --format=sdist

.PHONY: psr-bump
psr-bump: 
	@echo "Semantic release! Bumping version and building changelog..." 
	$(POETRY) run semantic-release version --no-vcs-release --no-tag --no-push

.PHONY: psr-changelog
psr-changelog:  
	@echo "Semantic release! Updating changelog..."  
	$(POETRY) run semantic-release changelog 

.PHONY: psr-publish
psr-publish: 
	@echo "Semantic release! Updating version, changelog & Publishing to git..." 
	$(POETRY) run semantic-release version