.. title: Deploying a Static Blog to Github Pages
.. slug: deploying-static-blog-to-github-pages
.. date: 2015-01-06 16:02:53 UTC-05:00
.. tags: github, static-generators
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


Deploying a Static Blog to Github Pages
=======================================


One of the challenges when deploying a static blog site to `Github Pages <https://pages.github.com>`_ is having a good workflow for accomplishing the task easily. By default Github Pages will use Jekyll to build your site for you, but if you're using something else besides Jekyll, then you're on your own.

For my static blog site (powered by `Python <https://www.python.org/>`_ and `Nikola <http://getnikola.com>`_), I decided to take the following approach:

- Have two repositories: (1) for the `source code <https://github.com/dgilland/blog>`_ and (2) for the `deployed site <https://github.com/dgilland/dgilland.github.io>`_.
- Only maintain version history in the source code repository (1) while deploying a snapshot with no history to (2).
- Have a single command for deployment.


.. TEASER_END


I'm partial to using `Make <http://www.gnu.org/software/make/>`_ for creating a simple command line interface for a project. For my ``Makefile`` I used several variables to make the command targets cleaner:


.. code-block:: makefile

    # Python virtualenv
    ENV_NAME = env

    # Prefix command to execute Python code from virtualenv
    ENV_ACT = . env/bin/activate &&

    # Shortcut to invoke the nikola command line interface from virtualenv
    NIKOLA = $(ENV_ACT) cd $(BLOG_DIR) && nikola

    # Source of site
    BLOG_DIR = blog

    # Build output for site
    OUTPUT_DIR = $(BLOG_DIR)/output

    # Staging folder for built site
    STAGING_DIR = site

    # Github Page remote
    ORIGIN = git@github.com:dgilland/dgilland.github.io.git

    # Website domain (used for CNAME file)
    DOMAIN = derrickgilland.com


The first step when deploying is to build the site from the source:


.. code-block:: makefile

    html:
        $(NIKOLA) build

        ## or fully expanded:
        # . env/bin/activate && cd blog && nikola build


However, this command alone isn't sufficient for a Nikola site since Nikola's build process doesn't clean the output directory before building. This could result in previously built files that are no longer a part of the source from making their way to the deployed site. To workaround this simply remove the output directory first:


.. code-block:: makefile

    clean-output:
        rm -rf $(OUTPUT_DIR)

        ## or fully expanded:
        # rm -rf blog/output


Next, combine ``make html`` and ``make clean-output`` into a single command (it's still useful to have ``make html`` as a separate command for faster builds during development since Nikola utilizes `doit <http://pydoit.org/>`_ to speed up build times):


.. code-block:: makefile

    new-html: clean-output html


Now that we have our pre-deployment build command, we need the actual deployment target which will take our clean HTML output and send it to our Github Page repository:


.. code-block:: makefile

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

        ## or expanded out and in simpler terms:
        ## Delete staging folder.
        # rm -rf site

        ## Copy output directory to staging folder.
        # cp -r blog/output site
        # cd site

        ## When hosting a root domain on Github Pages, a CNAME file is needed.
        # echo derrickgilland.com > CNAME

        ## tell Github not to run Jekyll on the site
        # touch .nojekyll

        ## Initialize a new repository.
        # git init

        ## Commit all files.
        # git add .
        # git commit -m "Build site"

        ## Add git remote
        # git remote add origin git@github.com:dgilland/dgilland.github.io.git

        ## Overwrite any existing history so that there is only a single commit
        # git push -u --force origin master


You'll notice that this command combines quite a few instructions which makes it a good candidate for conversion into a shell script proper. However, for this project I prefer to keep the implementation simple by leaving it fully defined in the makefile.

Finally, to wrap things up, create a composite target which calls both ``make new-html`` and ``make deploy``:


.. code-block:: makefile

    publish: new-html deploy


Now we have our single command for full deployment which can be executed from the command line:


.. code-block:: bash

    make publish


The current makefile I'm using looks something like this:


.. code-block:: makefile

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


The full source is available on `Github <https://github.com/dgilland/blog/blob/master/makefile>`_. Feel free to modify it to suite your own needs
