.. title: pydash: Release v3.2.0
.. slug: pydash-release-v320
.. date: 2015-03-03 17:30:41 UTC-05:00
.. tags: pydash, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pydash v3.2.0 <https://github.com/dgilland/pydash/tree/v3.2.0>`_ has been released.

It was a minor feature release with a bugfix.


.. TEASER_END


.. include:: snippets/what-is-pydash.rst


.. include:: snippets/download-pydash.rst


Changes
-------

Features
++++++++

- Added ``sort_by_order`` as alias of ``sort_by_all``.
- Made ``sort_by_all`` accept an ``orders`` argument for specifying the sort order of each key via boolean ``True`` (for ascending) and ``False`` (for descending).
- Made ``words`` accept a ``pattern`` argument to override the default regex used for splitting words.
- Made ``words`` handle single character words better.

Bug Fixes
+++++++++

- Fix ``is_match`` to not compare ``obj`` and ``source`` types using ``type`` and instead use ``isinstance`` comparisons exclusively.
