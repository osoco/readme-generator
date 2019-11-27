.DEFAULT_GOAL := help

.PHONY: help

# Variables
# ----------------------------------------------------------------------

# Auto documentation
# ----------------------------------------------------------------------

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m%s\n", $$1, $$2}' | sed -e 's/\[32m## /[33m/'

help-nocolor:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s%s\n", $$1, $$2}' | sed -e 's/## //'

##
## Clean
## -----

mrproper: ## Delete all artefacts
	@rm -rf Pharo.image Pharo.changes PharoDebug.log pharo-vm pharo-local pharo-ui pharo

##
## Build
## -------

build: get-image install ## Build README Generator

get-image: ## Download the latest stable Pharo image and VM
	@curl get.pharo.org/64/stable+vm | bash

install: get-image ## Install README Generator and dependencies
	@./pharo Pharo.image metacello install "github://osoco/READMEGenerator/src" BaselineOfReadmeGenerator

##
## Docker
## ------

build-docker: build ## Run all tests
	@docker build -t readme-generator .


##
## Running
## -------

run: ## Run the generator
	@docker run -v $$(pwd):/data osoco/readme-generator:latest --outputFile=README.md
