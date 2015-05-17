.. title: Flask-LogConfig: Release v0.3.0
.. slug: flask-logconfig-release-v030
.. date: 2015-01-26 19:27:51 UTC-05:00
.. tags: flask-logconfig, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Flask-LogConfig v0.3.0 <https://github.com/dgilland/flask-logconfig/tree/v0.3.0>`_ has been released.

It was a feature release with backwards incompatible changes. A major new feature added was the ability to log all requests. The biggest breaking change was renaming the config key prefix from ``LOGGING*`` to ``LOGCONFIG*``.


.. TEASER_END


.. include:: snippets/what-is-flask-logconfig.rst


.. include:: snippets/download-flask-logconfig.rst


Changes
-------

Features
++++++++

- Add support for logging all requests.
- Don't store any application specific state on ``LogConfig`` class. Move ``LogConfig.listeners`` access to ``LogConfig.get_listeners``. **(breaking change)**
- Make ``LogConfig.__init__`` and ``LogConfig.init_app`` accept custom queue class via ``queue_class`` argument.
- Make ``LogConfig.start_listeners()`` and ``LogConfig.stop_listeners()`` accept optional ``app`` argument to access listeners associated with that app. If no ``app`` passed in, then ``flask.current_app`` will be accessed.
- Rename supported configuration keys from ``LOGGING`` and ``LOGGING_QUEUE``to ``LOGCONFIG`` and ``LOGCONFIG_QUEUE`` respectively. **(breaking change)**

Bug Fixes
+++++++++

None
