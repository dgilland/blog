.. title: First Post
.. slug: first-post
.. date: 2014-01-02 15:52:00 UTC-05:00
.. tags: static-generators, python
.. author: Derrick Gilland
.. description:


First Post
==========

I always thought that my first blog would be backed by something like `Wordpress <https://wordpress.org/>`_, but that was years ago. Now that I've actually built one, I've chosen a static site generator instead. Before implementing this site, I researched several static blog engines to find the one I felt most comfortable with. Along the way, I looked at `Pelican <http://blog.getpelican.com/>`_, `Tinkerer <http://tinkerer.me/>`_, and `Nikola <http://getnikola.com/>`_. My main requirements for a static blogging platform were:

- Easy of use
- Supports reStructuredText
- Uses Jinja for templating
- Sufficient features
- Not overly complicated


Pelican
-------

Pelican seemed like a solid choice and is for most people (it's the most starred Python generator on `Static Gen <https://www.staticgen.com/>`_). It supports `reStructuredText <http://docutils.sourceforge.net/rst.html>`_, `Markdown <http://daringfireball.net/projects/markdown/>`_, or `AsciiDoc <http://www.methods.co.nz/asciidoc/>`_ formats, it's based on `Jinja <http://jinja.pocoo.org/>`_, it's easy to use, and has a good community. However, right before I was set to commit to Pelican, a friend of mine pointed out that the project was `AGPL <http://choosealicense.com/licenses/agpl-3.0/>`_. Yikes, no thanks! I'd prefer a project with a more permissive license, e.g., `MIT <http://choosealicense.com/licenses/mit/>`_ or `BSD <http://choosealicense.com/licenses/bsd-2-clause/>`_.


Tinkerer
--------

My first impression of Tinkerer was its simplicity and the fact that it utilized `Sphinx <http://sphinx-doc.org/>`_ for site generation. I'm somewhat familiar with Sphinx since I use it for documentation generation for some of my open source projects. It also utilized `HTML5 Boilerplate <http://html5boilerplate.com/>`_ out of the box which is a good base for templating. I actually chose this generator and deployed the site using it. However, one thing kept nagging at me and that was how Tinkerer organizes posts. Instead of reading the date from post metadata defined in the file, it utilizes a date aware file structure (e.g. ``/2015/01/02/post-name.rst``). I thought I would be able to live with this but the more I thought about, the more it became a deal breaker. I had previously created the site template to be compatible with Tinkerer so I wasn't thrilled with having to port it over to another platform.


Nikola
------

I actually considered Nikola twice. The first time was right after I considered Pelican. I found Nikola to be similar to Pelican in scope and features with the exception that Nikola was permissively licensed (MIT). However, during my first run through of Nikola, I thought that it was perhaps more complex than what I needed. So I went with Tinkerer only to abandoned it to come back to Nikola. I ported my Tinkerer theme to Nikola and ran through Nikola's documentation in more detail. It turned out that many of the features that Nikola supported were things that Tinkerer didn't:

- Easy bundling of assets via `webassets <https://webassets.readthedocs.org/en/latest/>`_
- Support for running CSS / JS compression
- Sitemap generation
- Single folder for posts
- Pretty URLs (e.g. ``/mypost/`` instead of ``/mypost.html``)

I'm glad I gave Nikola another chance. It's actually been easier to set up and use than I anticipated so I'm satisfied with my choice.


What To Expect from This Blog
-----------------------------

I plan to mostly blog about software development with a specific focus on Python, my main programming language.hi.
