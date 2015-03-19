.. title: Late Value Passing for Lazy Method Chaining in Python
.. slug: late-value-passing-for-lazy-method-chaining-in-python
.. date: 2015-03-18 17:43:34 UTC-04:00
.. tags: pydash, python, generative-classes
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


This is part three in my series on `Generative Classes <link://tag/generative-classes>`_.


In part two of this series, `Lazy Method Chaining in Python <link://slug/lazy-method-chaining-in-python>`_, I showed an example of how to implement lazy method chaining. In this post I will build upon that implementation by building support for a way to pass the seed value of the lazy method chain late, i.e., at the end of the chain instead of at the beginning. This will then allow us to easily create reusable ad-hoc functions from chained methods.

The example code I will use to discuss this type of functionality can be found in `pydash's <http://pydash.readthedocs.org/en/latest/>`_ `chaining submodule <https://github.com/dgilland/pydash/blob/44ff5f94870be48908c8b1eb1623559b88164dad/pydash/chaining.py>`_:


.. TEASER_END


.. code-block:: python

    from __future__ import absolute_import

    import pydash
    from .helpers import NoValue


    class Chain(object):
        """Enables chaining of 'module' functions."""

        #: Object that contains attribute references to available methods.
        module = pydash

        def __init__(self, value=NoValue):
            self._value = value

        def value(self):
            """Return current value of the chain operations."""
            return self(self._value)

        @classmethod
        def get_method(cls, name):
            """Return valid 'module' method."""
            method = getattr(cls.module, name, None)

            if not callable(method):
                raise cls.module.InvalidMethod(('Invalid pydash method: {0}'
                                                .format(name)))

            return method

        def __getattr__(self, attr):
            """Proxy attribute access to 'module'."""
            return ChainWrapper(self._value, self.get_method(attr))

        def __call__(self, value):
            """Return result of passing 'value' through chained methods."""
            if isinstance(self._value, ChainWrapper):
                value = self._value.unwrap(value)
            return value


    class ChainWrapper(object):
        """Wrap 'Chain' method call within a 'ChainWrapper' context."""
        def __init__(self, value, method):
            self._value = value
            self.method = method
            self.args = ()
            self.kargs = {}

        def _generate(self):
            """Generate a copy of this instance."""
            new = self.__class__.__new__(self.__class__)
            new.__dict__ = self.__dict__.copy()
            return new

        def unwrap(self, value=NoValue):
            """Execute 'method' with '_value', 'args', and 'kargs'. If '_value' is
            an instance of 'ChainWrapper', then unwrap it before calling 'method'.
            """
            # Generate a copy of ourself so that we don't modify the chain wrapper
            # _value directly. This way if we are late passing a value, we don't
            # "freeze" the chain wrapper value when a value is first passed.
            # Otherwise, we'd locked the chain wrapper value permanently and not be
            # able to reuse it.
            wrapper = self._generate()

            if isinstance(wrapper._value, ChainWrapper):
                wrapper._value = wrapper._value.unwrap(value)
            elif not isinstance(value, ChainWrapper) and value is not NoValue:
                # Override wrapper's initial value.
                wrapper._value = value

            if wrapper._value is not NoValue:
                value = wrapper._value

            return wrapper.method(value, *wrapper.args, **wrapper.kargs)

        def __call__(self, *args, **kargs):
            """Invoke the 'method' with 'value' as the first argument and return a
            new 'Chain' object with the return value.
            """
            self.args = args
            self.kargs = kargs
            return Chain(self)


    def chain(value):
        """Creates a 'Chain' object which wraps the given value to enable
        intuitive method chaining. Chaining is lazy and won't compute a final value
        until 'Chain.value' is called.
        """
        return Chain(value)


**NOTE:** The code above has been simplified for illustrative purposes.


Usage
=====

Early value passing should look familiar:


.. code-block:: python

    chained = Chain([1, 2, 3, 4]).power(2).sum()
    assert isinstance(chained, Chain)

    # NOTE: No actual function calls have been executed for power() or sum() yet.
    # The chaining is lazy until value() is called.

    results = chained.value()
    assert results == 30


Late value passing is almost identical except for how the value is passed in and the fact that the chain function can be reused:


.. code-block:: python

    square_sum = Chain().power(2).sum()
    assert isinstance(square_sum, Chain)

    results = square_sum([1, 2, 3, 4])
    assert results == 30

    results = square_sum([5, 6, 7, 8])
    assert results = 174


Breakdown
=========

The main difference between our first lazy chaining implementation and our new late-value implementation is in the ``ChainWrapper.unwrap`` method.

The original implementation:


.. code-block:: python

    class ChainWrapper(object):
        """Wrap pydash method call within a ChainWrapper context."""
        def __init__(self, value, method):
            self._value = value
            self.method = method
            self.args = ()
            self.kargs = {}

        def unwrap(self):
            """Execute method with _value, args, and kargs. If _value is an
            instance of ChainWrapper, then unwrap it before calling method.
            """
            if isinstance(self._value, ChainWrapper):
                self._value = self._value.unwrap()
            return self.method(self._value, *self.args, **self.kargs)

        def __call__(self, *args, **kargs):
            """Invoke the method with value as the first argument and return a new
            Chain object with the return value.
            """
            self.args = args
            self.kargs = kargs
            return Chain(self)


The ``unwrap`` method in the original was very simple. If the underlying ``self._value`` was an instance of ``ChainWrapper``, then it would be recursively unwrapped until the root value was reached. Then the root value would be passed back through the ``ChainWrapper``'s for the final value calculation.


The late-value implementation:


.. code-block:: python

    class ChainWrapper(object):
        """Wrap 'Chain' method call within a 'ChainWrapper' context.
        """
        def __init__(self, value, method):
            self._value = value
            self.method = method
            self.args = ()
            self.kargs = {}

        def _generate(self):
            """Generate a copy of this instance."""
            new = self.__class__.__new__(self.__class__)
            new.__dict__ = self.__dict__.copy()
            return new

        def unwrap(self, value=NoValue):
            """Execute 'method' with '_value', 'args', and 'kargs'. If '_value' is
            an instance of 'ChainWrapper', then unwrap it before calling 'method'.
            """
            # Generate a copy of ourself so that we don't modify the chain wrapper
            # _value directly. This way if we are late passing a value, we don't
            # "freeze" the chain wrapper value when a value is first passed.
            # Otherwise, we'd locked the chain wrapper value permanently and not be
            # able to reuse it.
            wrapper = self._generate()

            if isinstance(wrapper._value, ChainWrapper):
                wrapper._value = wrapper._value.unwrap(value)
            elif not isinstance(value, ChainWrapper) and value is not NoValue:
                # Override wrapper's initial value.
                wrapper._value = value

            if wrapper._value is not NoValue:
                value = wrapper._value

            return wrapper.method(value, *wrapper.args, **wrapper.kargs)

        def __call__(self, *args, **kargs):
            """Invoke the 'method' with 'value' as the first argument and return a
            new 'Chain' object with the return value.
            """
            self.args = args
            self.kargs = kargs
            return Chain(self)


Now, the ``unwrap`` method has become a little more complex. In order to be reusable, the ``ChainWrapper`` instance is cloned using the ``_generate`` method. This method should look familiar; it was introduced in part one of this series, `Introduction to Generative Classes in Python <link://slug/introduction-to-generative-classes-in-python>`_. After cloning we then check whether the underlying ``wrapper._value`` is an instance of ``ChainWrapper`` so we can unwrap it to ultimately reach the start of the chain. Once the start of the chain is reached, the passed in ``value`` is seeded as the root value. Then the root value is passed through the chain just like in the original implementation. To facilitate the late value passing in the main ``Chain`` class, a ``__call__`` method was added which accepts a passed in value to use as the root value of the chain. With the new late value passing feature, the lazy chaining implementation now supports ad-hoc function creation via chaining syntax.

In part four of this series, I will investigate implementing a ``plant`` method for ``Chain`` which will supplant a new initial value as the wrapped value and return a clone of the chain.


.. include:: snippets/generative-classes-series.rst