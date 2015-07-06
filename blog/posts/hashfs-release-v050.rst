.. title: hashfs: Release v0.5.0
.. slug: hashfs-release-v050
.. date: 2015-07-06 18:01:14 UTC-04:00
.. tags: hashfs, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`HashFS v0.5.0 <https://github.com/dgilland/hashfs/tree/v0.5.0>`_ has been released.

It was a minor feature release that added an ``is_duplicate`` attribute to ``HashAddress``.


.. TEASER_END


.. include:: snippets/what-is-hashfs.rst


.. include:: snippets/download-hashfs.rst


Changes
-------

Features
++++++++

- Rename private method ``HashFS.copy`` to ``HashFS._copy``.
- Add ``is_duplicate`` attribute to ``HashAddress``.
- Make ``HashFS.put()`` return ``HashAddress`` with ``is_duplicate=True`` when file with same hash already exists on disk.


Bug Fixes
+++++++++

None
