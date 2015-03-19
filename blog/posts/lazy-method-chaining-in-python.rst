.. title: Lazy Method Chaining in Python
.. slug: lazy-method-chaining-in-python
.. date: 2015-02-03 22:15:07 UTC-05:00
.. tags: pydash, python, generative-classes
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


This is part two in my series on `Generative Classes <link://tag/generative-classes>`_.


Building upon my previous post, `Introduction to Generative Classes in Python <link://slug/introduction-to-generative-classes-in-python>`_, I'd like to explore how to implement lazy method chaining where execution of each method is deferred until explicitly called.

The example code I will use to discuss this type of functionality can be found in `pydash's <http://pydash.readthedocs.org/en/latest/>`_ `chaining submodule <https://github.com/dgilland/pydash/blob/238edf01805eee678263cedcfa807a88f9310d3a/pydash/chaining.py>`_:


.. TEASER_END


.. code-block:: python

    from __future__ import absolute_import

    import pydash


    class Chain(object):
        """Enables chaining of pydash functions."""

        def __init__(self, value):
            self._value = value

        def value(self):
            """Return current value of the chain operations."""
            if isinstance(self._value, ChainWrapper):
                self._value = self._value.unwrap()
            return self._value

        @staticmethod
        def get_method(name):
            """Return valid pydash method."""
            method = getattr(pydash, name, None)

            if not callable(method):
                raise pydash.InvalidMethod('Invalid pydash method: {0}'.format(name))

            return method

        def __getattr__(self, attr):
            """Proxy attribute access to pydash."""
            return ChainWrapper(self._value, self.get_method(attr))


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


    def chain(value):
        """Creates a 'Chain' object which wraps the given value to enable
        intuitive method chaining. Chaining is lazy and won't compute a final value
        until 'Chain.value' is called.
        """
        return Chain(value)


**NOTE:** The code above has been simplified for illustrative purposes.


Usage
=====

The direct usage of ``Chain`` looks like this:


.. code-block:: python

    chained = Chain([1, 2, 3, 4]).power(2).sum()
    assert isinstance(chained, Chain)

    # NOTE: No actual function calls have been executed for power() or sum() yet.
    # The chaining is lazy until value() is called.

    results = chained.value()
    assert results == 30


However, if using ``pydash`` directly, it would look like this:


.. code-block:: python

    results = pydash.chain([1, 2, 3, 4]).power(2).sum().value()

    # Or by using the "_" instance...
    results = pydash._([1, 2, 3, 4]).power(2).sum().value()


Breakdown
=========

Let's start by breaking ``Chain`` and ``ChainWrapper`` down into understandable chunks:


.. code-block:: python

    # From Chain
    @staticmethod
    def get_method(name):
        """Return valid pydash method."""
        method = getattr(pydash, name, None)

        if not callable(method):
            raise pydash.InvalidMethod('Invalid pydash method: {0}'.format(name))

        return method


The ``get_method`` static method attempts to retrieve a module function from ``pydash``. If the function doesn't exist, an ``InvalidMethod`` exception is raised.


.. code-block:: python

    # From Chain
    def __getattr__(self, attr):
        """Proxy attribute access to pydash."""
        return ChainWrapper(self._value, self.get_method(attr))


The ``__getattr__`` magic method proxies attribute access on ``Chain`` to return a ``ChainWrapper`` instance with the attribute value corresponding to a ``pydash`` module function. This is what allows ``Chain([]).power`` to work where ``power`` is ``pydash.power``.

Using the ``ChainWrapper`` class is what allows the proxied method to be called with positional or keyword arguments:


.. code-block:: python

    # From ChainWrapper
    def __call__(self, *args, **kargs):
        """Invoke the method with value as the first argument and return a new
        Chain object with the return value.
        """
        self.args = args
        self.kargs = kargs
        return Chain(self)


The ``ChainWrapper`` ``__call__`` method returns a new ``Chain`` instance with the ``Chain``'s value being set to the ``ChainWrapper`` instance. The ``ChainWrapper`` instance acts as a placeholder for the future function call. Essentially, ``ChainWrapper`` represents a step in the operation chain which will be unwrapped later. This is what gives ``Chain`` its lazy property. It isn't until ``Chain.value()`` is called that all of the underlying ``ChainWrapper``'s are unwrapped:


.. code-block:: python

    # From Chain
    def value(self):
        """Return current value of the chain operations."""
        if isinstance(self._value, ChainWrapper):
            self._value = self._value.unwrap()
        return self._value


    # From ChainWrapper
    def unwrap(self):
        """Execute method with _value, args, and kargs. If _value is an
        instance of ChainWrapper, then unwrap it before calling method.
        """
        if isinstance(self._value, ChainWrapper):
            self._value = self._value.unwrap()
        return self.method(self._value, *self.args, **self.kargs)


When ``Chain.value`` is called, a recursive operation is initiated with an inital call to the top-most ``ChainWrapper``. Within the ``ChainWrapper.unwrap`` method, if ``_value`` is another ``ChainWrapper``, it, too, is unwrapped until all ``ChainWrapper``'s have been processed. At that point, the bottom of the chain is reached and the function calls begin to bubble back up with each function's result being passed to the next operation in the chain until all functions have been executed. Once all of the functions have returned a value, the final value is stored in ``Chain`` so that future access to ``.value()`` won't invoke the chained methods again.

In the next post of this series, I will outline how to modify the ``Chain`` and ``ChainWrapper`` classes to allow for late passing of the initial ``value`` of the chain which will result in the ability to re-use method chains as ad-hoc functions.


.. include:: snippets/generative-classes-series.rst
