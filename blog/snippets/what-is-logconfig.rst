What is logconfig?
------------------

This simple library exposes several helper methods for configuring the standard library's `logging module <https://docs.python.org/library/logging.html>`_. There's nothing fancy about it. Under the hood logconfig uses `logging.config <https://docs.python.org/library/logging.config.html>`_ to load various configuartion formats.

In addition to configuration loading, logconfig provides helpers for easily converting a configured logger's handlers to utilize a queue.

It is Python 2.6+ and 3.3+ compatible.