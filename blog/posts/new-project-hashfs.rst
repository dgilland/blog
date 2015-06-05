.. title: New Project: hashfs
.. slug: new-project-hashfs
.. date: 2015-06-05 18:01:21 UTC-04:00
.. tags: python, hashfs
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


I've started a new Python project: `hashfs <https://github.com/dgilland/hashfs>`_

HashFS is

    A content-addressable file management system for Python


The major features of HashFS are

- Files are stored once and never duplicated.
- Uses an efficient folder structure optimized for a large number of files. File paths are based on the content hash and are nested based on the first ``n`` number of characters.
- Can save files from local file paths or readable objects (open file handlers, IO buffers, etc).
- Able to repair the root folder by reindexing all files. Useful if the hashing algorithm or folder structure options change or to initialize existing files.
- Supports any hashing algorithm available via ``hashlib.new``.
- Python 2.7+/3.3+ compatible.


.. TEASER_END


Current Release
---------------

As of this writing, the latest version of hashfs is `v0.4.0 <https://github.com/dgilland/hashfs/tree/v0.4.0>`_.


Sample Usage
============

``HashFS`` supports basic file storage, retrieval, and removal as well as some more advanced features like file repair.


Storing Content
---------------

Add content to the folder using either readable objects (e.g. ``StringIO``) or file paths (e.g. ``'a/path/to/some/file'``).


.. code-block:: python

    from io import StringIO

    some_content = StringIO('some content')

    address = fs.put(some_content)

    # Or if you'd like to save the file with an extension...
    address = fs.put(some_content, '.txt')

    # The id of the file (i.e. the hexdigest of its contents).
    address.id

    # The absolute path where the file was saved.
    address.abspath

    # The path relative to fs.root.
    address.relpath


Retrieving Content
------------------

Get a ``BufferedReader`` handler for an existing file by address ID or path.


.. code-block:: python

    fileio = fs.open(address.id)

    # Or using the full path...
    fileio = fs.open(address.abspath)

    # Or using a path relative to fs.root
    fileio = fs.open(address.relpath)


Removing Content
----------------

Delete a file by address ID or path.


.. code-block:: python

    fs.delete(address.id)
    fs.delete(address.abspath)
    fs.delete(address.relpath)


For more details, please see the full documentation at http://hashfs.readthedocs.org and follow development at https://github.com/dgilland/hashfs.
