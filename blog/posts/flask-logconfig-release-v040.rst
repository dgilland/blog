.. title: Flask-LogConfig: Release v0.4.0
.. slug: flask-logconfig-release-v040
.. date: 2015-02-03 22:46:13 UTC-05:00
.. tags: flask-logconfig, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Flask-LogConfig v0.4.0 <https://github.com/dgilland/flask-logconfig/tree/v0.4.0>`_ has been released.

It was a minor feature release that added ``execution_time`` to the request log data. Some possible breaking changes were introduced as well.


.. TEASER_END


.. include:: snippets/what-is-flask-logconfig.rst


.. include:: snippets/download-flask-logconfig.rst


Changes
-------

Features
++++++++

- Added ``execution_time`` to log's extra data and request message data.
- Renamed ``FlaskLogConfig.after_request_handler`` to ``FlaskLogConfig.after_request``. **(possible breaking change)**
- Renamed ``FlaskLogConfig.get_request_msg_data`` to ``FlaskLogConfig.get_request_message_data``. **(possible breaking change)**
- Renamed ``FlaskLogConfig.make_request_msg`` to ``FlaskLogConfig.make_request_message``. **(possible breaking change)**

Bug Fixes
+++++++++

None
