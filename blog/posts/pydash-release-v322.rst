.. title: pydash: Release v3.2.2
.. slug: pydash-release-v322
.. date: 2015-04-30 18:37:39 UTC-04:00
.. tags: pydash, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pydash v3.2.2 <https://github.com/dgilland/pydash/tree/v3.2.2>`_ has been released.

It was bugfix release with no new features.


.. TEASER_END


.. include:: snippets/what-is-pydash.rst


.. include:: snippets/download-pydash.rst


Changes
-------

Features
++++++++

None

Bugfixes
++++++++

- Catch ``AttributeError`` in ``helpers.get_item`` and return default value if set.
- Fix bug in ``reduce_right`` where collection was not reversed correctly.
