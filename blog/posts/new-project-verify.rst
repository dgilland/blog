.. title: New Project: verify
.. slug: new-project-verify
.. date: 2015-05-12 18:49:21 UTC-04:00
.. tags: python, verify
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


I've started a new Python project: `verify <https://github.com/dgilland/verify>`_

Verify is billed as

    A painless assertion and validation library for Python

Why make this when similar libraries already exist? Simply, I wanted a library with the following features:


.. TEASER_END


- All objects raise an ``AssertionError`` when invalid.
- Ability to easily apply multiple assertions to a single value either via method chaining or passing multiple arguments to an assertion runner function.
- Simple callables as assertions.
- Support for using external predicate functions for validation.


Current Release
---------------

As of this writing, the latest version of verify is `v0.5.0 <https://github.com/dgilland/verify/tree/v0.5.0>`_. It has 70 assertion methods and `100% test coverage <https://coveralls.io/builds/2547639>`_.


Sample Usage
------------

Using verify is simple:

.. code-block:: python

    import verify as v

    # These will pass.
    v.expect(5 * 5, v.Truthy(), v.Greater(15), v.Less(30))
    v.Truthy(1)
    v.Equal(2, 2)
    v.Greater(3, 2)

    # These will fail with an AssertionError
    v.Truthy(0)
    v.Equal(2, 3)
    v.Greater(2, 3)

    # Using custom assert functions
    def is_just_right(value):
        assert value == 'just right', 'Not just right!'
        return True

    # Passes
    expect('just right', is_just_right)

    # Fails
    try:
        expect('too cold', is_just_right)
    expect AssertionError:
        raise

    # Using custom predicate functions
    def is_awesome(value):
        return 'awesome' in value

    def is_more_awesome(value):
        return value > 'awesome'

    expect('so awesome', is_awesome, is_more_awesome)


Looking Ahead
-------------

Active development is underway with the goal of releasing ``v1.0.0`` soon to lock in a stable API. You can track or contribute to verify on `Github <https://github.com/dgilland/verify>`_.
