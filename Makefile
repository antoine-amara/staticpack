DC = docker-compose
YN = yarn
WEBSITE = website
DEPLOY = docker run -it --env-file ${PWD}/deploy/gcp/configs.env -v ${PWD}/deploy/gcp/:/deploy/ -v ${PWD}/dist/:/dist/ -w /deploy/ --rm staticpack-gcp-terraform:332.0.0-alpine

default: help;

init:	## build, install dependencies and run the development environment. The environment will run in watch mode.
	${DC} build
	${MAKE} dependencies
	${DC} up -d
	${DC} ps
	cp ./deploy/gcp/configs.env.dist ./deploy/gcp/configs.env

run:	## build the production bundle and run it.
	${DC} run -p 3000:3000 --rm ${WEBSITE} ${YN} serve

watch:	## build the development bundle and run it with a live reload.
	${DC} up -d
	${DC} ps

build:	## build the production bundle in the dist folder
	${DC} run --rm ${WEBSITE} ${YN} build

package: ## build the production bundle and zip it as website.zip.
	${DC} run --rm ${WEBSITE} ${YN} package

clean: ## clean builded assets
	${DC} run --rm ${WEBSITE} rm -rf ./dist/ ./website.zip ./stats.json

check: style test	## run the linter to check code formating and unit tests to check javascripts libs.

style:	## run the linter to check code formating.
	${DC} run --rm ${WEBSITE} ${YN} lint
	${DEPLOY} terraform fmt -write=true -recursive .
	${DEPLOY} terraform validate

test:	## run the unit tests to check javascript libs.
	${DC} run --rm ${WEBSITE} ${YN} test

restart: destroy watch	## restart the development environment. This command can be used only on watch mode.

command:	## run a command inside the development environment, pass your command with cmd=<your command> arg. (nodejs LTS runtime and yarn package manager are available).
	${DC} run --rm ${WEBSITE} ${cmd}

dependencies: ## run the package manager to install all dependencies.
	${DC} run --rm ${WEBSITE} ${YN} install

logs:	## display logs from the development server. This command can be used only on watch mode.
	${DC} logs -f ${WEBSITE}

destroy:	## switch off and destroy the development server instance. This command can be used only on watch mode.
	${DC} down

release-github:	## create a release push on master and create a github release with the git meta-data. example to release a minor: 'make github-release gh-token="<token>" target="minor"'
	git checkout master
	${MAKE} release target=${target}
	git push --tags origin master
	${DC} run --rm -e CONVENTIONAL_GITHUB_RELEASER_TOKEN=${gh-token} ${WEBSITE} ${YN} release-github

release:	## create a release with a target (major, minor or patch), increment the version into package.json, create the Changelog, and finally create a git tag and commit it. example to release a minor: 'make release target="minor"'.
	${DC} run -v ~/.gitconfig:/etc/gitconfig --rm ${WEBSITE} ${YN} release -- --release-as ${target}

analyze:	## build the production bundle and run the bundle analyzer which will output an interactive treemap representing your bundle.
	${DC} run -p 9042:9042 --rm  ${WEBSITE} ${YN} analyze-bundle

reset-linter:
	${DC} run --rm ${WEBSITE} npm uninstall eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise
	${DC} run --rm ${WEBSITE} npx eslint --init

build-gcp-image:	## build the docker image used to deploy the static assets to gcp with terraform.
	docker build ./Docker/gcp-terraform --tag staticpack-gcp-terraform:332.0.0-alpine

gcp-init:	## download terraform dependencies and init the module.
	${DEPLOY} terraform init

gcp-deploy: build build-gcp-image gcp-init	## command to deploy the website to gcp cloud.
	${DEPLOY} terraform apply

gcp-destroy:	## command to delete the website from gcp cloud.
	${DEPLOY} terraform destroy

help:		## show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: 
	init run watch package clean check style test restart command dependencies logs destroy release-github release analyze build-gcp-image gcp-init gcp-deploy gcp-destroy help
.SILENT: 
	init run watch package clean check style test restart command dependencies logs destroy release-github release analyze build-gcp-image gcp-init gcp-deploy gcp-destroy help
