.. title: verify: Release v1.1.0
.. slug: verify-release-v110
.. date: 2015-07-23 18:31:47 UTC-04:00
.. tags: verify, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Verify v1.1.0 <https://github.com/dgilland/verify/tree/v1.1.0>`_ has been released.

It was a feature release with several new method alias groups to help with constructing more natural sounding assertion statements.


.. TEASER_END


Before this release, assertion statements would use Pascal case assertion methods:


.. code-block:: python

    from verify import expect

    expect(some_value).Float().Greater(5)


With the ``v1.1.0`` release, assertion statements can be constructred using either ``Expect...To Be`` or ``Ensure...Is`` aliases.


.. code-block:: python

    from verify import expect, ensure

    expect(some_value).to_be_float().to_be_greater_than(5).to_not_be_equal(3.5)
    ensure(some_value).is_float().is_greater_than(5).is_not_equal(3.5)


While it's encouraged to stick with one style or another, styles can be interchanged between ``expect`` and ``ensure`` to produce the same results.


.. code-block:: python

    ensure(some_value).Float().is_greater_than(5).to_not_be_equal(3.5)


.. include:: snippets/what-is-verify.rst


.. include:: snippets/download-verify.rst


Changes
-------

Features
++++++++

- Add ``ensure`` as alias of ``expect``.
- Add ``to_be_*`` and ``is_*`` aliases for all assertions.


Bug Fixes
+++++++++

None
