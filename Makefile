DC = docker-compose
YN = yarn

default: help;

init:	## build, install dependencies and run the development environment. The environment will run in watch mode.
	${DC} build
	${MAKE} dependencies
	${DC} up -d
	${DC} ps

run:	## build the production bundle and run it.
	${DC} run -p 3000:3000 --rm node ${YN} serve

watch:	## build the development bundle and run it with a live reload.
	${DC} up -d
	${DC} ps

package: ## build the production bundle and zip it as website.zip.
	${DC} run --rm node ${YN} package

clean: ## clean builded assets
	${DC} run --rm node rm -rf ./dist/ ./website.zip ./stats.json

check:	## run the linter to check code formating and unit tests to check javascripts libs.
	${MAKE} style
	${MAKE} test

style:	## run the linter to check code formating.
	${DC} run --rm node ${YN} lint

test:	## run the unit tests to check javascript libs.
	${DC} run --rm node ${YN} test

restart:	## restart the development environment. This command can be used only on watch mode.
	${DC} stop
	${MAKE} watch

command:	## run a command inside the development environment, pass your command with cmd=<your command> arg. (nodejs LTS runtime and yarn package manager are available).
	${DC} run --rm node ${cmd}

dependencies: ## run the package manager to install all dependencies.
	${DC} run --rm node ${YN} install

logs:	## display logs from the development server. This command can be used only on watch mode.
	${DC} logs -f node

destroy:	## switch off and destroy the development server instance. This command can be used only on watch mode.
	${DC} down

release:	## create a release with a target (major, minor or patch), increment the version into package.json, create the Changelog, and finally create a git tag and commit it. example to release a minor: 'make release target="minor"'.
	${DC} run --rm node ${YN} release -- --release-as ${target}

analyze:	## build the production bundle and run the bundle analyzer which will output an interactive treemap representing your bundle.
	${DC} run -p 9042:9042 --rm  node ${YN} analyze-bundle

help:		## show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: 
	init run watch package clean check style test restart command dependencies logs destroy release analyze help
.SILENT: 
	init run watch package clean check style test restart command dependencies logs destroy release analyze help
