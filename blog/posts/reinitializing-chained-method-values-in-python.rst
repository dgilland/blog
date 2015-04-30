.. title: Reinitializing Chained Method Values in Python
.. slug: reinitializing-chained-method-values-in-python
.. date: 2015-04-30 19:15:23 UTC-04:00
.. tags:
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


This is part four in my series on `Generative Classes <link://tag/generative-classes>`_.


In part three of this series, `Late Value Passing for Lazy Method Chaining in Python <link://slug/late-value-passing-for-lazy-method-chaining-in-python>`_, I covered a methodology for creating reusable, ad-hoc functions from chained methods by passing the initial chain value late (i.e. after the method chain had been built up). In this post I will outline a way to replace the initial chain value by returning a clone of the method chains reinitialized with the replacement value.

The example code I will use to discuss this type of functionality can be found in `pydash's <http://pydash.readthedocs.org/en/latest/>`_ `chaining submodule <https://github.com/dgilland/pydash/blob/e7890117f3184dbe5bd7deb09a5eaf217180cb0a/pydash/chaining.py>`_:


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

        def plant(self, value):
            """Return a clone of the chained sequence planting value as the
            wrapped value.
            """
            wrapper = self._value
            wrappers = []

            if hasattr(wrapper, '_value'):
                wrappers = [wrapper]

                while isinstance(wrapper._value, ChainWrapper):
                    wrapper = wrapper._value
                    wrappers.insert(0, wrapper)

            clone = Chain(value)

            for wrap in wrappers:
                clone = ChainWrapper(clone._value, wrap.method)(*wrap.args,
                                                                **wrap.kargs)

            return clone

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

Our new reinitializer method is ``plant`` and can be used in the following way:


.. code-block:: python

    sum_square_one_to_four = Chain([1, 2, 3, 4]).power(2).sum()
    sum_square_five_to_eight = sum_square_one_to_four.plant([5, 6, 7, 8])

    assert sum_square_one_to_four.value() == 30
    assert sum_square_five_to_eight.value() == 174


Breakdown
=========

The approach taken to reinitialize a set of chained methods is to essentially replay the sequence of method chaining on a new instance of ``Chain``. The ``plant`` method implements this idea:


.. code-block:: python

    def plant(self, value):
        """Return a clone of the chained sequence planting value as the
        wrapped value.
        """
        wrapper = self._value
        wrappers = []

        if hasattr(wrapper, '_value'):
            wrappers = [wrapper]

            while isinstance(wrapper._value, ChainWrapper):
                wrapper = wrapper._value
                wrappers.insert(0, wrapper)

        clone = Chain(value)

        for wrap in wrappers:
            clone = ChainWrapper(clone._value, wrap.method)(*wrap.args,
                                                            **wrap.kargs)

        return clone


We start by referencing the initial value of the chain. Then we check whether it has the attribute ``_value``. If it does, this indicates that the current value stored in the chain has had at least one method chain applied to it. We then want to loop back through each ``ChainWrapper`` until we get to the initial value that was passed in via ``Chain(value)``. As we loop through each ``wrapper._value`` and as long as ``wrapper._value`` is an instance of ``ChainWrapper``, we build a list of ``ChainWrapper`` instances in reverse order via ``wrappers.insert(0, wrapper)``. We'll need this list in reverse order since we are starting with the last ``ChainWrapper`` and going backwards through each method chain call. So when we clone it, we'll proceed back through each method chain in the original order.


.. code-block:: python

    wrapper = self._value
    wrappers = []

    if hasattr(wrapper, '_value'):
        wrappers = [wrapper]

        while isinstance(wrapper._value, ChainWrapper):
            wrapper = wrapper._value
            wrappers.insert(0, wrapper)


After we have our list of chain wrappers, we create a new ``Chain`` instance with the ``value`` we are planting. Then we loop through the ``wrappers`` and rebuild the method chain by referencing the ``method``, ``args``, and ``kargs`` attributes of each ``ChainWrapper`` instance.


.. code-block:: python

    clone = Chain(value)

    for wrap in wrappers:
        clone = ChainWrapper(clone._value, wrap.method)(*wrap.args,
                                                        **wrap.kargs)

    return clone


The end result is a new ``Chain`` instance cloned from the original with a new initial value planted.

This concludes my series on Generative Classes. You can read the previous posts below:


.. include:: snippets/generative-classes-series.rst
