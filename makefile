##
# Variables
##

# Python virtualenv
ENV_NAME = env

# Prefix command to execute Python code from virtualenv
ENV_ACT = . env/bin/activate &&

# Shortcut to invoke pip command from virtualenv
PIP = $(ENV_NAME)/bin/pip

# Shortcut to invoke the nikola command line interface from virtualenv
NIKOLA = $(ENV_ACT) cd $(BLOG_DIR) && nikola

# Source of site
BLOG_DIR = blog

# Build output for site
OUTPUT_DIR = $(BLOG_DIR)/output

# Staging folder for built site used for deployment
STAGING_DIR = site

# Github Page remote
ORIGIN = git@github.com:dgilland/dgilland.github.io.git

# Website domain (used for CNAME file)
DOMAIN = derrickgilland.com


##
# Targets
##

# Build Python virtualenv
.PHONY: build
build: clean install

# Remove build files.
.PHONY: clean
clean: clean-env clean-files clean-output clean-staging

# Remove virtualenv.
.PHONY: clean-env
clean-env:
	rm -rf $(ENV_NAME)

# Remove Python setup build files.
.PHONY: clean-files
clean-files:
	rm -rf .tox
	rm -rf .coverage
	find . -name \*.pyc -type f -delete
	find . -name \*.test.db -type f -delete
	find . -depth -name __pycache__ -type d -exec rm -rf {} \;
	rm -rf dist *.egg* build

# Remove site build output folder.
.PHONY: clean-output
clean-output:
	rm -rf $(OUTPUT_DIR)

# Remove site staging folder.
.PHONY: clean-staging
clean-staging:
	rm -rf $(STAGING_DIR)

# Install Python virtualenv
.PHONY: install
install:
	rm -rf $(ENV_NAME)
	virtualenv --no-site-packages $(ENV_NAME)
	$(PIP) install -r requirements.txt

# Create new blog post.
.PHONY: post
post:
	$(NIKOLA) new_post

# Create new blog page.
.PHONY: page
page:
	$(NIKOLA) new_page

# Run spell checker on file.
.PHONY: spellcheck
spellcheck:
	aspell check $(f)

# Build HTML site.
.PHONY: html
html:
	$(NIKOLA) build

# Build HTML site after removing output folder.
.PHONY: new-html
new-html: clean-output html

# Serve site using dev server.
.PHONY: serve
serve:
	$(NIKOLA) serve

# Run html and serve targets.
.PHONY: reload
reload: html serve

# Deploy built site to repository.
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

# Run new-html and deploy targets.
.PHONY: publish
publish: new-html deploy
