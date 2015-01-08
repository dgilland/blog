##
# Variables
##

ENV_NAME = env
ENV_ACT = . env/bin/activate &&
PIP = $(ENV_NAME)/bin/pip
BLOG_DIR = blog
OUTPUT_DIR = $(BLOG_DIR)/output
STAGING_DIR = site
ORIGIN = git@github.com:dgilland/dgilland.github.io.git
DOMAIN = derrickgilland.com
NIKOLA = $(ENV_ACT) cd $(BLOG_DIR) && nikola

##
# Targets
##
.PHONY: build
build: clean install

.PHONY: clean
clean: clean-env clean-files clean-output clean-staging

.PHONY: clean-env
clean-env:
	rm -rf $(ENV_NAME)

.PHONY: clean-files
clean-files:
	rm -rf .tox
	rm -rf .coverage
	find . -name \*.pyc -type f -delete
	find . -name \*.test.db -type f -delete
	find . -depth -name __pycache__ -type d -exec rm -rf {} \;
	rm -rf dist *.egg* build

.PHONY: clean-output
clean-output:
	rm -rf $(OUTPUT_DIR)

.PHONY: clean-staging
clean-staging:
	rm -rf $(STAGING_DIR)

.PHONY: install
install:
	rm -rf $(ENV_NAME)
	virtualenv --no-site-packages $(ENV_NAME)
	$(PIP) install -r requirements.txt

.PHONY: post
post:
	$(NIKOLA) new_post

.PHONY: page
page:
	$(NIKOLA) new_page

.PHONY: spellcheck
spellcheck:
	aspell check $(f)

.PHONY: html
html:
	$(NIKOLA) build

.PHONY: new-html
new-html: clean-output html

.PHONY: serve
serve:
	$(NIKOLA) serve

.PHONY: reload
reload: html serve

.PHONY: deploy
deploy:
	rm -rf $(STAGING_DIR) && \
	cp -r $(OUTPUT_DIR) $(STAGING_DIR)
	cd $(STAGING_DIR) && \
	echo $(DOMAIN) > CNAME && \
	touch .nojekyll && \
	git init && \
	git add . && \
	git commit -m "Build site" && \
	git remote add origin $(ORIGIN) && \
	git push -u --force origin master

.PHONY: publish
publish: new-html deploy