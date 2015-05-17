.. title: pydash: Release v3.0.0
.. slug: pydash-release-v300
.. date: 2015-02-25 20:53:55 UTC-05:00
.. tags: pydash, python, release
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


`Pydash v3.0.0 <https://github.com/dgilland/pydash/tree/v3.0.0>`_ has been released.

It was a major version release with over 40 new functions, enhanced chaining functionality, bug fixes, and several backwards incompatible changes.

Please see the `Upgrade Guide <http://pydash.readthedocs.org/en/latest/upgrading.html>`_ when transitioning from ``v2.x.x`` to ``v3.0.0``.


.. TEASER_END


.. include:: snippets/what-is-pydash.rst


.. include:: snippets/download-pydash.rst


Changes
-------

Features
++++++++

- Add ``ary``.
- Add ``chars``.
- Add ``chop``.
- Add ``chop_right``.
- Add ``clean``.
- Add ``commit`` method to ``chain`` that returns a new chain with the computed ``chain.value()`` as the initial value of the chain.
- Add ``count_substr``.
- Add ``decapitalize``.
- Add ``duplicates``.
- Add ``has_substr``.
- Add ``human_case``.
- Add ``insert_substr``.
- Add ``is_blank``.
- Add ``is_bool`` as alias of ``is_boolean``.
- Add ``is_builtin``, ``is_native``.
- Add ``is_dict`` as alias of ``is_plain_object``.
- Add ``is_int`` as alias of ``is_integer``.
- Add ``is_match``.
- Add ``is_num`` as alias of ``is_number``.
- Add ``is_tuple``.
- Add ``join`` as alias of ``implode``.
- Add ``lines``.
- Add ``number_format``.
- Add ``pascal_case``.
- Add ``plant`` method to ``chain`` that returns a cloned chain with a new initial value.
- Add ``predecessor``.
- Add ``property_of``, ``prop_of``.
- Add ``prune``.
- Add ``re_replace``.
- Add ``rearg``.
- Add ``replace``.
- Add ``run`` as alias of ``chain.value``.
- Add ``separator_case``.
- Add ``series_phrase``.
- Add ``series_phrase_serial``.
- Add ``slugify``.
- Add ``sort_by_all``.
- Add ``strip_tags``.
- Add ``substr_left``.
- Add ``substr_left_end``.
- Add ``substr_right``.
- Add ``substr_right_end``.
- Add ``successor``.
- Add ``swap_case``.
- Add ``title_case``.
- Add ``truncate`` as alias of ``trunc``.
- Add ``to_boolean``.
- Add ``to_dict``, ``to_plain_object``.
- Add ``to_number``.
- Add ``underscore_case`` as alias of ``snake_case``.
- Add ``unquote``.
- Make the following functions work with empty strings and ``None``: (**breaking change**) Thanks k7sleeper_!

  - ``camel_case``
  - ``capitalize``
  - ``chars``
  - ``chop``
  - ``chop_right``
  - ``class_case``
  - ``clean``
  - ``count_substr``
  - ``decapitalize``
  - ``ends_with``
  - ``join``
  - ``js_replace``
  - ``kebab_case``
  - ``lines``
  - ``quote``
  - ``re_replace``
  - ``replace``
  - ``series_phrase``
  - ``series_phrase_serial``
  - ``starts_with``
  - ``surround``

- Make callback invocation have better support for builtin functions and methods. Previously, if one wanted to pass a builtin function or method as a callback, it had to be wrapped in a lambda which limited the number of arguments that would be passed it. For example, ``_.each([1, 2, 3], array.append)`` would fail and would need to be converted to ``_.each([1, 2, 3], lambda item: array.append(item)``. That is no longer the case as the non-wrapped method is now supported.
- Make ``capitalize`` accept ``strict`` argument to control whether to convert the rest of the string to lower case or not. Defaults to ``True``.
- Make ``chain`` support late passing of initial ``value`` argument.
- Make ``chain`` not store computed ``value()``. (**breaking change**)
- Make ``drop``, ``drop_right``, ``take``, and ``take_right`` have default ``n=1``.
- Make ``is_indexed`` return ``True`` for tuples.
- Make ``partial`` and ``partial_right`` accept keyword arguments.
- Make ``pluck`` style callbacks support deep paths.
- Make ``re_replace`` accept non-string arguments.
- Make ``sort_by`` accept ``reverse`` parameter.
- Make ``splice`` work with strings.
- Make ``to_string`` convert ``None`` to empty string. (**breaking change**)
- Move ``arrays.join`` to ``strings.join``. (**breaking change**)
- Rename ``join``/``implode``'s second parameter from ``delimiter`` to ``separator``. (**breaking change**)
- Rename ``split``/``explode``'s second parameter from ``delimiter`` to ``separator``. (**breaking change**)
- Reorder function arguments for ``after`` from ``(n, func)`` to ``(func, n)``. (**breaking change**)
- Reorder function arguments for ``before`` from ``(n, func)`` to ``(func, n)``. (**breaking change**)
- Reorder function arguments for ``times`` from ``(n, callback)`` to ``(callback, n)``. (**breaking change**)
- Reorder function arguments for ``js_match`` from ``(reg_exp, text)`` to ``(text, reg_exp)``. (**breaking change**)
- Reorder function arguments for ``js_replace`` from ``(reg_exp, text, repl)`` to ``(text, reg_exp, repl)``. (**breaking change**)
- Support iteration over class instance properties for non-list, non-dict, and non-iterable objects.


Bug Fixes
+++++++++

- Fix ``deep_has`` to return ``False`` when ``ValueError`` raised during path checking.
- Fix ``pad`` so that it doesn't over pad beyond provided length.
- Fix ``trunc``/``truncate`` so that they handle texts shorter than the max string length correctly.


.. _k7sleeper: https://github.com/k7sleeper