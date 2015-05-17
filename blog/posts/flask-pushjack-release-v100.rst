.. title: Flask-Pushjack: Release v1.0.0
.. slug: flask-pushjack-release-v100
.. date: 2015-04-30 18:36:54 UTC-04:00
.. tags: flask-pushjack, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Flask-Pushjack v1.0.0 <https://github.com/dgilland/flask-pushjack/tree/v1.0.0>`_ has been released.

It was the first major version release that brings the API inline with `pushjack v1.0.0 <https://github.com/dgilland/pushjack/tree/v1.0.0>`_. There were a few backwards incompatible changes as well. The biggest breaking change is that ``pushjack 1.0.0`` eliminated the ``send_bulk`` method which is now replaced by the ``send`` method. See the release notes for `v1.0.0 of pushjack <link://slug/pushjack-release-v100>`_ for more details.


.. TEASER_END

.. include:: snippets/what-is-flask-pushjack.rst


.. include:: snippets/download-flask-pushjack.rst


Changes
-------

Features
++++++++

- Add ``APNS_DEFAULT_BATCH_SIZE=100`` config option.
- Pin ``pushjack`` dependency version to ``>=1.0.0``. (**breaking change**)
- Remove ``send_bulk`` method as bulk sending is now accomplished by the ``send`` function. (**breaking change**)
- Remove ``APNS_HOST``, ``APNS_PORT``, ``APNS_FEEDBACK_HOST``, and ``APNS_FEEDBACK_PORT`` config options. These are now determined by whether ``APNS_SANDBOX`` is ``True`` or not.
- Remove ``APNS_MAX_NOTIFICATION_SIZE`` as config option.
- Remove ``GCM_MAX_RECIPIENTS`` as config option.
- Rename ``APNS_ERROR_TIMEOUT`` config option to ``APNS_DEFAULT_ERROR_TIMEOUT``. (**breaking change**)

Bug Fixes
+++++++++

None
