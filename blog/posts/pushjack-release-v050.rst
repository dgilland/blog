.. title: pushjack: Release v0.5.0
.. slug: pushjack-release-v050
.. date: 2015-04-24 19:32:42 UTC-04:00
.. tags: pushjack, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pushjack v0.5.0 <https://github.com/dgilland/pushjack/tree/v0.5.0>`_ has been release.

It was a major release that improves the APNS send algorithm. There were also two backwards incompatible changes.


.. TEASER_END


The APNS send algorithm has been modified to resume sending whenever an error response is encountered. Previously, whenever an error response occurred, an exception would be raised potentially before all notifications had been sent. It would have been up to the user to catch these exceptions and resume sending since any notifications sent to tokens after the error token would never be delivered. With this update APNS sending will handle error responses and restart sending from after the error token. All error responses are collected and raised once sending has been attempted for all tokens. Therefore, if an error is encountered during sending, an ``APNSSendError`` which contains information about the notifications that couldn't be delivered will be raised.

The second breaking change is that the APNS send argument ``priority`` has been replaced with ``low_priority=False``. Previously, one had to pass in the appropriate priority value (either ``10`` or ``5``). Since there are only two possible priority levels, it made since to eliminate the raw value passing and instead convert to a boolean argument.

Please see the `Upgrade Guide <http://pushjack.readthedocs.org/en/latest/upgrading.html#from-v0-4-0-to-v0-5-0>`_ when transitioning from ``v0.4.0`` to ``v0.5.0``.


.. include:: snippets/what-is-pushjack.rst


.. include:: snippets/download-pushjack.rst


Changes
-------

Features
++++++++

- Add new APNS configuration value ``APNS_DEFAULT_BATCH_SIZE`` and set to ``100``.
- Add ``batch_size`` parameter to APNS ``send`` that can be used to override ``APNS_DEFAULT_BATCH_SIZE``.
- Make APNS ``send`` batch multiple notifications into a single payload. Previously, individual socket writes were performed for each token. Now, socket writes are batched based on either the ``APNS_DEFAULT_BATCH_SIZE`` configuration value or the ``batch_size`` function argument value.
- Make APNS ``send`` resume sending from after the failed token when an error response is received.
- Make APNS ``send`` raise an ``APNSSendError`` when one or more error responses received. ``APNSSendError`` contains an aggregation of errors, all tokens attempted, failed tokens, and successful tokens. (**breaking change**)
- Replace ``priority`` argument to APNS ``send`` with ``low_priority=False``. (**breaking change**)

Bugfixes
++++++++

None
