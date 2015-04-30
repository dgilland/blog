.. title: pushjack: Release v1.0.0
.. slug: pushjack-release-v100
.. date: 2015-04-30 09:36:39 UTC-04:00
.. tags: pushjack, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pushjack v1.0.0 <https://github.com/dgilland/pushjack/tree/v1.0.0>`_ has been release.

It was the first major version release with several breaking changes. Most of the breaking changes were related to cleaning up and removing parts of the API to simplify the overall implementation. There are no longer two ways to send a notification (one using a client class and one using a module function). Instead, client classes are the one way to do that. The configuration object has also been removed and replaced with initialization parameters to the client classes. And finally the APNS send method now returns an object (just like GCM sending does) instead of raising an exception.

For more details, please see the `Upgrade Guide <http://pushjack.readthedocs.org/en/latest/upgrading.html#from-v0-5-0-to-v1-0-0>`_.


.. TEASER_END


.. include:: snippets/what-is-pushjack.rst


.. include:: snippets/download-pushjack.rst


Changes
-------

Features
++++++++

- Add ``APNSSandboxClient`` for sending notifications to APNS sandbox server.
- Add ``message`` attribute to ``APNSResponse``.
- Add internal logging.
- Make APNS sending stop during iteration if a fatal error is received from APNS server (e.g. invalid topic, invalid payload size, etc).
- Make APNS and GCM clients maintain an active connection to server.
- Make APNS always return ``APNSResponse`` object instead of only raising ``APNSSendError`` when errors encountered. (**breaking change**)
- Remove APNS/GCM module send functions and only support client interfaces. (**breaking change**)
- Remove ``config`` argument from ``APNSClient`` and use individual method parameters as mapped below instead: (**breaking change**)

    - ``APNS_ERROR_TIMEOUT`` => ``default_error_timeout``
    - ``APNS_DEFAULT_EXPIRATION_OFFSET`` => ``default_expiration_offset``
    - ``APNS_DEFAULT_BATCH_SIZE`` => ``default_batch_size``

- Remove ``config`` argument from ``GCMClient`` and use individual method parameters as mapped below instead: (**breaking change**)

    - ``GCM_API_KEY`` => ``api_key``

- Remove ``pushjack.clients`` module. (**breaking change**)
- Remove ``pushjack.config`` module. (**breaking change**)
- Rename ``GCMResponse.payloads`` to ``GCMResponse.messages``. (**breaking change**)

Bugfixes
++++++++

- Fix APNS error checking to properly handle reading when no data returned.

