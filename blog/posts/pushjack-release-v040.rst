.. title: pushjack: Release v0.4.0
.. slug: pushjack-release-v040
.. date: 2015-04-16 18:54:25 UTC-04:00
.. tags: pushjack, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pushjack v0.4.0 <https://github.com/dgilland/pushjack/tree/v0.4.0>`_ has been release.

It was a major release with several backwards incompatible changes. The biggest breaking change is that the ``send_bulk`` function has been eliminated with its functionality being merged into the ``send`` function (i.e. sending single or multiple push notification is done with the same function). The other big change is that the APNS socket connection handling has been changed to non-blocking and utilizes I/O multiplexing via the `select <https://docs.python.org/library/select.html>`_ module.

Please see the `Upgrade Guide <http://pushjack.readthedocs.org/en/latest/upgrading.html#from-v0-3-0-to-v0-4-0>`_ when transitioning from ``v0.3.0`` to ``v0.4.0``.


.. TEASER_END

.. include:: snippets/what-is-pushjack.rst


.. include:: snippets/download-pushjack.rst


Changes
-------

Features
++++++++

- Improve error handling in APNS so that errors aren't missed.
- Improve handling of APNS socket connection during bulk sending so that connection is re-established when lost.
- Make APNS socket read/writes non-blocking.
- Make APNS socket frame packing easier to grok.
- Remove APNS and GCM ``send_bulk`` function. Modify ``send`` to support bulk notifications. (**breaking change**)
- Remove ``APNS_MAX_NOTIFICATION_SIZE`` as config option.
- Remove ``GCM_MAX_RECIPIENTS`` as config option.
- Remove ``request`` argument from GCM send function. (**breaking change**)
- Remove ``sock`` argument from APNS send function. (**breaking change**)
- Return namedtuple for GCM canonical ids.
- Return namedtuple class for APNS expired tokens.


Bugfixes
++++++++

None
