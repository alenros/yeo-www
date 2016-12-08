WORKDIR = $(shell pwd)

CSS_DIR = public/css
CSS_FILE = $(CSS_DIR)/style.css
CSS_REV = main-$(shell md5 -r $(WORKDIR)/$(CSS_FILE) | awk '{print $$1}').css

server:
	hugo server --theme=yeo --buildDrafts --watch

asset:
	cp $(CSS_FILE) "$(CSS_DIR)/main-$(shell md5 -r $(CSS_FILE) | awk '{print $$1}').css"
	echo $(CSS_REV)
	find public -name "*.html" -print0 | xargs -0 -I filename /bin/bash -c "echo filename; sed 's/css\/style.css/css\/$(CSS_REV)/g' filename > tmp; mv tmp filename"

generate:
	hugo --theme=yeo

build: generate asset

build_draft:
	hugo --theme=yeo --buildDrafts

add_subtree:
	git subtree add --prefix=public origin public --squash

pull_subtree:
	git subtree pull --prefix=public origin public

push_subtree:
	git subtree push --prefix=public origin public

deploy: push_subtree

ssh_deploy:
	ssh kurei@noty "bash deploy-yeo.sh"
