.PHONY: clean build build-docker run test .m2 .env

# Set the default target to be the help for this Makefile
.DEFAULT_GOAL: help
SHELL:=bash
PROJECT=helloworld

M2_DIR?=$(HOME)/.m2

DOCKER_JDK_IMAGE=maven:3.6.3-jdk-8-slim
DOCKER_VOLUMES=-v `pwd`:/usr/$(PROJECT) -v $(M2_DIR):/root/.m2 -w /usr/$(PROJECT)
VERSION=$(shell cat pom.xml | grep "^.*<version>.*</version>$$"| head -1 | awk -F'[><]' '{print $$3}')

include .env

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo $(PROJECT):$(VERSION)
	@echo "==========================================================="
	@echo $(DESC)
	@echo M2_DIR: $(M2_DIR)
	@echo The targets available in this project are:
	@grep -h -E '^[a-zA-Z0-9_%/-\.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

.m2:
	@mkdir -p $(M2_DIR)
	@cp -f config/settings.xml $(M2_DIR)

.env:
	touch .env

clean: ## Clean (mvn clean)
clean: .env .m2
	@docker run -it  --rm $(DOCKER_VOLUMES) $(DOCKER_JDK_IMAGE) mvn clean

package: ## Build the jar package (mvn package)
package: .env .m2
	@docker run -it  --rm $(DOCKER_VOLUMES) $(DOCKER_JDK_IMAGE) mvn package

build-docker: ## Builds the docker image
build-docker:
	@echo 'Building Docker image...'
	@docker build -t $(PROJECT):$(VERSION) .

build: ## Full build (jar + docker)
build: package build-docker
	@echo "Building jar and docker image"

deploy: ## Deploy
deploy: .env .m2
	@docker run -it --env-file .env --rm $(DOCKER_VOLUMES) $(DOCKER_JDK_IMAGE) mvn deploy

run: ## Runs app in a docker container
run: .env
	docker run -it $(PROJECT):$(VERSION)

test: ## Run Test
test: .env .m2
	@docker run -it  --rm $(DOCKER_VOLUMES) $(DOCKER_JDK_IMAGE) mvn verify