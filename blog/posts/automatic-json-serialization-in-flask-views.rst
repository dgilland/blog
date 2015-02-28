.. title: Automatic JSON Serialization in Flask Views
.. slug: automatic-json-serialization-in-flask-views
.. date: 2015-02-27 20:27:00 UTC-05:00
.. tags: flask, json, python
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland



Wouldn't it be great if your `Flask Views <http://flask.pocoo.org/docs/tutorial/views/>`_ could automatically serialize lists and dicts to JSON? That instead of having to decorate views or explicitly call `flask.jsonify <http://flask.pocoo.org/docs/api/#flask.json.jsonify>`_ on the output, you could just return the bare list or dict from the view function.

This can be accomplished with the following snippet:


.. TEASER_END


.. code-block:: python

    from flask import Flask, Response, current_app, json, request


    class ResponseJSON(Response):
        """Extend flask.Response with support for list/dict conversion to JSON."""
        def __init__(self, content=None, *args, **kargs):
            if isinstance(content, (list, dict)):
                kargs['mimetype'] = 'application/json'
                content = to_json(content)

            super(Response, self).__init__(content, *args, **kargs)

        @classmethod
        def force_type(cls, response, environ=None):
            """Override with support for list/dict."""
            if isinstance(response, (list, dict)):
                return cls(response)
            else:
                return super(Response, cls).force_type(response, environ)


    def to_json(content):
        """Converts content to json while respecting config options."""
        indent = None
        separators = (',', ':')

        if (current_app.config['JSONIFY_PRETTYPRINT_REGULAR']
                and not request.is_xhr):
            indent = 2
            separators = (', ', ': ')

        return (json.dumps(content, indent=indent, separators=separators), '\n')


    class FlaskJSON(Flask):
        """Extension of standard Flask app with custom response class."""
        response_class = ResponseJSON


    app = FlaskJSON(__name__)


    @app.route('/demo/list/')
    def demo_list():
        return ['this', 'will', 'be', 'converted', 'to', 'a', 'json', 'list']


    @app.route('/demo/dict/')
    def demo_dict():
        return {'this': 'will', 'be': 'converted', 'to': 'a', 'json': 'dict'}


    with app.test_client() as client:
        print(client.get('/demo/list/').data)
        print(client.get('/demo/dict/').data)


Whenever a ``list`` or ``dict`` object is returned by a view function, the ``ResponseJSON`` class sets the ``mimetype`` to ``application/json`` and calls ``to_json`` on the object. The ``to_json`` function uses ``flask.json`` to serialize the object to JSON while respecting the ``JSONIFY_PRETTYPRINT_REGULAR`` config option. A newline is appended to the JSON string to be inline with `mitsuhiko/flask#1261 <https://github.com/mitsuhiko/flask/pull/1262>`_.
