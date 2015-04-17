.. title: Flask-Pushjack: Release v0.2.0
.. slug: flask-pushjack-release-v020
.. date: 2015-04-16 18:54:44 UTC-04:00
.. tags: flask-pushjack, pushjack, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Flask-Pushjack v0.2.0 <https://github.com/dgilland/flask-pushjack/tree/v0.2.0>`_ has been release.

It was a major release with several backwards incompatible changes. The biggest breaking change is that ``pushjack >=0.4.0`` is now being used which eliminated the ``send_bulk`` method which is now replaced by the ``send`` method. See the release notes for `pushjack v0.4.0 <link://slug/pushjack-release-v040>`_ for more details.


.. TEASER_END

.. include:: snippets/what-is-flask-pushjack.rst


.. include:: snippets/download-flask-pushjack.rst


Changes
-------

Features
++++++++

- Pin ``pushjack`` dependency version to ``>=0.4.0``. (**breaking change**)
- Remove ``send_bulk`` method as bulk sending is now accomplished by the ``send`` function. (**breaking change**)
- Remove ``APNS_MAX_NOTIFICATION_SIZE`` as config option.
- Remove ``GCM_MAX_RECIPIENTS`` as config option.


Bugfixes
++++++++

None
