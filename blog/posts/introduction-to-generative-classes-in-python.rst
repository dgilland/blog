.. title: Introduction to Generative Classes in Python
.. slug: introduction-to-generative-classes-in-python
.. date: 2015-01-20 18:17:18 UTC-05:00
.. tags: python, generative-classes
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


This is part one in my series on `Generative Classes <link://tag/generative-classes>`_.


A Python Generative Class is defined as

    a class that returns or clones, i.e. generates, itself when accessed by certain means

This type of class can be used to implement method chaining or to mutate an object's state without modifying the original class instance.


An example of a generative class would be one that supports method chaining:


.. TEASER_END


.. code-block:: python

    class Operation(object):
        def __init__(self, result=0):
            self.result = result

        def add(self, term):
            self.result += term
            return self

        def subtract(self, term):
            self.result -= term
            return self

    operator = Operation()
    operator.add(3).add(4).subtract(5)
    assert operator == 2


One potential issue with this approach (returning ``self`` after each method call) is that the original ``Operation`` instance is modified each time the generative methods are called. Sometimes it's more desirable to prevent the original object from being modified so that it can be reused in its original state and to prevent unintended side effects.

For example, this would not work as intended:


.. code-block:: python

    from5 = Operation(5)

    add7_to_5 = from5.add(7).result
    assert add7_to_5 == 12

    add3_to_5 = from5.add(3).result

    # This fails! The result is actually 15.
    assert add3_to_5 == 8


A more robust implementation would be to clone the original class instance when certain methods are accessed and return the new instance whose state is mutated by whatever operation is being performed:


.. code-block:: python

    class Operation(object):
        def __init__(self, result=0):
            self.result = result

        def add(self, term):
            return self.__class__(self.result + term)

        def subtract(self, term):
            return self.__class__(self.result - term)

    operator = Operation()
    result = operator.add(3).add(4).subtract(5).result

    assert result == 2
    assert operator.result == 0

    from5 = Operation(5)
    add7_to_5 = from5.add(7).result
    assert add7_to_5 == 12

    add3_to_5 = from5.add(3).result

    # This now passes!
    assert add3_to_5 == 8


However, this implementation contains some boilerplate (e.g. ``return self.__class__(...)``) which could become tedious to work with at scale. There's also the fact that the class has to be manually generated with the proper arguments which means if the ``__init__`` signature is changed, all of these references will have to be updated to match. This `Stackoverflow answer <http://stackoverflow.com/a/21785906/681166>`_ from `Martijn Pieters <http://stackoverflow.com/users/100297/martijn-pieters>`_ details a useful, generic implementation for creating generative classes:


.. code-block:: python

    from functools import wraps

    class GenerativeBase(object):
        def _generate(self):
            s = self.__class__.__new__(self.__class__)
            s.__dict__ = self.__dict__.copy()
            return s

    def _generative(func):
        @wraps(func)
        def decorator(self, *args, **kw):
            self = self._generate()
            func(self, *args, **kw)
            return self
        return decorator


**NOTE:** The code above is not exactly what appears in the Stackoverflow link. There was a typo that was corrected and posted to `Pastebin <http://pastebin.com/2Thdxjux>`_.

The main part of the ``GenerativeBase`` is the ``_generate`` method. It's main purpose is to create a new instance of the class and copy its ``__dict__`` state. When ``self.__class__.__new__(self.__class__)`` is called, it's equivalent to doing:


.. code-block:: python

    obj_to_clone = GenerativeBase()
    new_obj = GenerativeBase.__new__(GenerativeBase)
    new_obj.__dict__ = obj_to_clone.__dict__.copy()


It's worth noting that by using ``__new__``, the ``__init__`` method of the class will **not** be called. Because of this the generate function doesn't need to know how to initialize the new class instance; it just has to copy its state over (i.e. by copying ``__dict__``).

There are some gotchas to this approach that are related to ``__dict__.copy()``. The ``__dict__`` object is the class' namespace and will typically contain all of the state that needs to be copied over. However, there may be instances where this isn't the case and some data will be lost in translation. Another issue is that ``__dict__.copy()`` performs a shallow-copy. If there are complex objects (e.g. a nested ``dict``) stored in ``__dict__``, the generated class instance will end up sharing state with it's parent which could lead to some hard to find bugs. You can read more about Python's data model on `Python.org <https://docs.python.org/reference/datamodel.html>`_.

With that in mind, the original ``Operation`` class can be rewritten to utilize ``GenerativeBase``:


.. code-block:: python

    class Operation(GenerativeBase):
        def __init__(self, result=0):
            self.result = result

        @_generative
        def add(self, term):
            self.result += term

        @_generative
        def subtract(self, term):
            self.result -= term


This new implementation is much cleaner and avoids excessive boilerplate. It abstracts the generative handling into a `decorator <https://www.python.org/dev/peps/pep-0318/>`_ which allows one to define the generative methods without having to worry about the details of the generative implementation. However, it is prone to the gotchas mentioned above, but in most cases, it would be sufficient for implementing a generative class.


.. include:: snippets/generative-classes-series.rst
