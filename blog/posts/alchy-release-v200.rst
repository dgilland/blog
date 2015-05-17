.. title: alchy: Release v2.0.0
.. slug: alchy-release-v200
.. date: 2015-04-30 18:37:57 UTC-04:00
.. tags: alchy, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Alchy v2.0.0 <https://github.com/dgilland/alchy/tree/v2.0.0>`_ has been released.

It was a major version release with some new features and one breaking change.


.. TEASER_END


.. include:: snippets/what-is-alchy.rst


.. include:: snippets/download-alchy.rst


Changes
-------

Features
++++++++

- Add ``Query.index_by``.
- Add ``Query.chain``.
- Add ``pydash`` as dependency and incorporate into existing ``Query`` methods: ``map``, ``reduce``, ``reduce_right``, and ``pluck``.
- Improve logic for setting ``__tablename__`` to work with all table inheritance styles (joined, single, and concrete), to handle ``@declared_attr`` columns, and not to duplicate underscore characters. Thanks sethp_!
- Modify logic that sets a Model class' ``__table_args__`` and ``__mapper_args__`` (unless overridden in subclass) by merging ``__global_table_args__`` and ``__global_mapper_args__`` from all classes in the class's ``mro()`` with ``__local_table_args__`` and ``__local_mapper_args__`` from the class itself. A ``__{global,local}_{table,mapper}_args__`` may be callable or classmethod, in which case it is evaluated on the class whose ``__{table,mapper}_args__`` is being set. Thanks sethp_! (**breaking change**)

Bug Fixes
+++++++++

None


.. _sethp: https://github.com/https://github.com/seth-p
