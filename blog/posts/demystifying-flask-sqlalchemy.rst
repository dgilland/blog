.. title: Demystifying Flask-SQLAlchemy
.. slug: demystifying-flask-sqlalchemy
.. date: 2015-01-12 20:49:03 UTC-05:00
.. tags: flask, flask-sqlalchemy, sqlalchemy, alchy, flask-alchy, python
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


It seems that one of the biggest questions around `Flask-SQLAlchemy <https://pythonhosted.org/Flask-SQLAlchemy/>`_ is how to use `SQLAlchemy <http://www.sqlalchemy.org/>`_ models outside of a `Flask <flask.pocoo.org>`_ application. Several questions have been posted on sites like `Stackoverflow <http://stackoverflow.com/questions/19119725/how-to-use-flask-sqlalchemy-with-existing-sqlalchemy-model>`_ and `Reddit <http://www.reddit.com/r/flask/comments/2qxah2/how_to_access_flasksqlalchemy_models_outside/>`_. There is an open issue `on Github <https://github.com/mitsuhiko/flask-sqlalchemy/issues/98>`_ asking to document how to use your own `declarative base class <http://docs.sqlalchemy.org/en/latest/orm/extensions/declarative/api.html?highlight=declarative#module-sqlalchemy.ext.declarative>`_. As of this writing, there are even `several <https://github.com/mitsuhiko/flask-sqlalchemy/pull/240>`_ `pull <https://github.com/mitsuhiko/flask-sqlalchemy/pull/250>`_ `requests <https://github.com/mitsuhiko/flask-sqlalchemy/pull/255>`_ to make Flask-SQLAlchemy easier to work with in this regard. However, none of the answers or discussions really take the time to parse through what Flask-SQLAlchemy does internally and how you can effectively decouple SQLAlchemy model integration from Flask-SQLAlchemy.


.. TEASER_END


What is Flask-SQLAlchemy?
-------------------------

Flask-SQLAlchemy's functionality can be broken down into several core components:

- Database `session configuration <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L746>`_ and `session management <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L775>`_ within an HTTP request context
- Custom `signalling events <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L175>`_ that fire before and after models are committed and after a transaction rollback
- Custom `declarative <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L733>`_ `base <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L696>`_ `model <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L585>`_ with support for `query property <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L445>`_ and `pagination <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L296>`_
- Proxy access from the `extension instance <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L705>`_ to the `SQLAlchemy module <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L89>`_
- Other minor conveniences like `creating <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L922>`_/`dropping <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L930>`_ all models, `accessing model metadata <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L711>`_, `autogenerating table names <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L557>`_, and `applying driver hacks <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L792>`_

**NOTE:** The links to Flask-SQLAlchemy's source code are pinned to the latest commit at the time of this writing.


Database Session Configuration and Management
+++++++++++++++++++++++++++++++++++++++++++++

This part of Flask-SQLAlchemy is quite useful when using Flask since it handles the session configuration, setup, and teardown for you. The teardown part is especially useful since it cleans up the session after the HTTP request is finished (not doing this properly can lead to stale or error-locked sessions that need to be rolled back before being usable again).


Signalling Events
+++++++++++++++++

This is something I don't find that useful when using Flask-SQLAlchemy. SQLAlchemy already provides a more robust event interface for `core <http://docs.sqlalchemy.org/en/latest/core/event.html>`_ and and `ORM <http://docs.sqlalchemy.org/en/latest/orm/events.html>`_ events. Besides, it appears that this feature will be `deprecated <https://github.com/mitsuhiko/flask-sqlalchemy/pull/150#issuecomment-69002922>`_ in a `future version <https://github.com/mitsuhiko/flask-sqlalchemy/pull/256>`_.


Proxy Access to SQLAlchemy Module
+++++++++++++++++++++++++++++++++

When an instance of ``flask_sqlalchemy.SQLAlchemy`` is created, the entire SQLAlchemy module is `proxied to that instance <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L89>`_ along with a few other methods like `Table <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L95>`_, `relationship <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L96>`_, `dynamic loader <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L98>`_, etc. If your goal is to not tie yourself completely to Flask-SQLAlchemy, then there is no reason to use any of these attributes. It's much clearer to use the SQLAlchemy module directly anyway.


Declarative Base Model
++++++++++++++++++++++

This is probably the single biggest part of Flask-SQLAlchemy that gives people trouble when trying to de-couple SQLAlchemy from Flask. Many people start out using Flask-SQLAlchemy's declarative base model because it's quick and convenient:


.. code-block:: python

    from flask import Flask
    from flask_sqlalchemy import SQLAlchemy

    app = Flask(__name__)
    db = SQLAlchemy(app)

    class User(db.Model):
        # define user model
        pass


So what's wrong with this? The main problem is that ``db.Model`` is directly coupled to the ``SQLAlchemy`` instance. It's not portable in the same way that a regular declarative model class would be: it's not directly importable and it's coupled to the instance that is also responsible for managing the database session. The only way to share this model is to import the ``db`` object which ties all of your model definitions to Flask-SQLAlchemy and, subsequently, Flask.

However, Flask-SQLAlchemy's declarative base does provide some useful features like the ability to execute a query using the model's query property:


.. code-block:: python

    users = User.query.filter(User.active == True).all()
    # which is equivalent to...
    users = db.session.query(User).filter(User.active == True).all()


and pagination:

.. code-block:: python

    users = User.query.paginate(page=2, per_page=20)
    next_users = users.next()
    prev_users = user.prev()

But this isn't that hard to set up yourself when needed.


Decoupling Flask-SQLAlchemy
---------------------------

It's my opinion that the design of Flask-SQLAlchemy is hampered by the coupling of the declarative base model with the extension's class instance. The extension should really only be concerned with a few things:

- Database session configuration
- Database session management
- Configuration of the query property on a declarative base model *that is passed into the extension*

A separate library that provides the declarative base could then be created that would do what Flask-SQLAlchemy's base model does but not have the dependence on Flask and which would be easily usable in non-Flask contexts.

So what's the way forward for decoupling the declarative base from Flask-SQLAlchemy but still having SQLAlchemy models that behave as if they were using Flask-SQLAlchemy's ``Model`` class?


Creating a Declarative Base Model
+++++++++++++++++++++++++++++++++

First, we need to define our own declarative base model so that we aren't dependent on Flask-SQLAlchemy's. A good starting point would be to simply copy Flask-SQLAlchemy's own model class (renamed here to add distinction between the base model class and the declarative base class created by SQLAlchemy):


.. code-block:: python

    # in models/base.py

    class ModelBase(object):
        """Baseclass for custom user models."""

        #: the query class used. The `query` attribute is an instance
        #: of this class. By default a `BaseQuery` is used.
        query_class = BaseQuery

        #: an instance of `query_class`. Can be used to query the
        #: database for instances of this model.
        query = None


and, subsequently, we'll create the declarative base (ignore for the moment the ``query`` and ``query_class`` attributes; I'll come back to those shortly):


.. code-block:: python

    # in models/base.py

    from sqlalchemy.ext.declarative import declarative_base

    Model = declarative_base(cls=ModelBase)


This will become the common source for all future SQLAlchemy classes. For example:


.. code-block:: python

    # in models/user.py

    from .base import Model

    class User(Model):
        # define user model
        pass


Creating a Query Class Property
+++++++++++++++++++++++++++++++

The ``ModelBase`` definition above includes references to a query class and query property. The query class is either SQLAlchemy's ``orm.Query`` class or a child class that inherits from it. The query property is what allows the ``User.query`` style access and is easy to create, but does require access to the database session when setting up.

Again, basing our query class off of Flask-SQLAlchemy:


.. code-block:: python

    # in models/base.py

    from sqlalchemy import orm

    class BaseQuery(orm.Query):
        """The default query object used for models. This can be
        subclassed and replaced for individual models by setting
        the Model.query_class attribute. This is a subclass of a
        standard SQLAlchemy sqlalchemy.orm.query.Query class and
        has all the methods of a standard query as well.
        """

        def paginate(self, page, per_page=20, error_out=True):
            """Return `Pagination` instance using already defined query
            parameters.
            """
            if error_out and page < 1:
                raise IndexError

            if per_page is None:
                per_page = self.DEFAULT_PER_PAGE

            items = self.page(page, per_page).all()

            if not items and page != 1 and error_out:
                raise IndexError

            # No need to count if we're on the first page and there are fewer items
            # than we expected.
            if page == 1 and len(items) < per_page:
                total = len(items)
            else:
                total = self.order_by(None).count()

            return Pagination(self, page, per_page, total, items)


And our pagination class:


.. code-block:: python

    class Pagination(object):
        """Class returned by `Query.paginate`. You can also construct
        it from any other SQLAlchemy query object if you are working
        with other libraries. Additionally it is possible to pass
        ``None`` as query object in which case the `prev` and `next`
        will no longer work.
        """

        def __init__(self, query, page, per_page, total, items):
            #: The query object that was used to create this pagination object.
            self.query = query

            #: The current page number (1 indexed).
            self.page = page

            #: The number of items to be displayed on a page.
            self.per_page = per_page

            #: The total number of items matching the query.
            self.total = total

            #: The items for the current page.
            self.items = items

            if self.per_page == 0:
                self.pages = 0
            else:
                #: The total number of pages.
                self.pages = int(ceil(self.total / float(self.per_page)))

            #: Number of the previous page.
            self.prev_num = self.page - 1

            #: True if a previous page exists.
            self.has_prev = self.page > 1

            #: Number of the next page.
            self.next_num = self.page + 1

            #: True if a next page exists.
            self.has_next = self.page < self.pages

        def prev(self, error_out=False):
            """Returns a `Pagination` object for the previous page."""
            assert self.query is not None, \
                'a query object is required for this method to work'
            return self.query.paginate(self.page - 1, self.per_page, error_out)

        def next(self, error_out=False):
            """Returns a `Pagination` object for the next page."""
            assert self.query is not None, \
                'a query object is required for this method to work'
            return self.query.paginate(self.page + 1, self.per_page, error_out)


If you compare the above to Flask-SQLAlchemy's `BaseQuery <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L395>`_ and `Pagination <https://github.com/mitsuhiko/flask-sqlalchemy/blob/e05ffe15c0f2feac19bb02f417b473fd83c88d71/flask_sqlalchemy/__init__.py#L296>`_ classes, you'll notice that they differ slightly. I've taken the liberty of removing usage of the Flask specific function ``abort`` so that our implementation is not tied to Flask along with some other minor changes. Additional "glue" code would be needed to reintegrate that behavior when using the query class inside a Flask app but that is beyond the scope of this article.

For the query property functionality, we need to define our query property class:


.. code-block:: python

    # in models/base.py

    from sqlalchemy import orm

    class QueryProperty(object):
        """Query property accessor which gives a model access to query capabilities
        via `ModelBase.query` which is equivalent to ``session.query(Model)``.
        """
        def __init__(self, session):
            self.session = session

        def __get__(self, model, Model):
            mapper = orm.class_mapper(Model)

            if mapper:
                if not getattr(Model, 'query_class', None):
                    Model.query_class = BaseQuery

                query_property = Model.query_class(mapper, session=self.session())

                return query_property


and a helper method for attaching the query property to the model:


.. code-block:: python

    def set_query_property(model_class, session):
        model_class.query = QueryProperty(session)


Extending Flask-SQLAlchemy
--------------------------

Finally, we need to extend Flask-SQLAlchemy's ``SQLAlchemy`` class to work with custom declarative bases:


.. code-block:: python

    # in ext/database.py

    from flask_sqlalchemy import SQLAlchemy as SQLAlchemyBase

    from ..models.base import set_query_property

    class SQLAlchemy(SQLAlchemyBase):
        """Flask extension that integrates alchy with Flask-SQLAlchemy."""
        def __init__(self,
                     app=None,
                     use_native_unicode=True,
                     session_options=None,
                     Model=None):
            self.Model = Model

            super(SQLAlchemy, self).__init__(app,
                                             use_native_unicode,
                                             session_options)

        def make_declarative_base(self):
            """Creates or extends the declarative base."""
            if self.Model is None:
                self.Model = super(SQLAlchemyBase, self).make_declarative_base()
            else:
                set_query_property(self.Model, self.session)
            return self.Model



Now, we can replace the Flask-SQLAlchemy usage example with:


.. code-block:: python

    # in app.py

    from flask import Flask

    from .ext.database import SQLAlchemy
    from .models.base import Model

    app = Flask(__name__)
    db = SQLAlchemy(app, Model=Model)


The new usage is almost identical to the original except for the fact that the ``Model`` class is now defined outside of Flask-SQLAlchemy and can easily be used in non-Flask contexts.


Beyond Flask-SQLAlchemy
-----------------------

I mentioned above that it was my opinion that the base model and query classes should be separated from Flask-SQLAlchemy and converted into their own library. I explained the basic process for pulling those components from Flask-SQLAlchemy which could then be used as a basis for this new library. However, that was something that I already did with my own projects: `alchy <https://github.com/dgilland/alchy>`_ and `Flask-Alchy <https://github.com/dgilland/flask-alchy>`_.

Alchy was created from my desire to separate the model-related parts of Flask-SQLAlchemy into a stand-alone library that could be used anywhere. I would encourage you to check out the `docs <http://alchy.readthedocs.org/en/latest/>`_ for yourself to see what alchy has to offer. It goes well beyond Flask-SQLAlchemy to provide features like:

- Its own session manager: `alchy.Manager <http://alchy.readthedocs.org/en/latest/api.html#module-alchy.manager>`_
- Integration with SQLAlchemy's `ORM events <http://docs.sqlalchemy.org/en/latest/orm/events.html>`_ at the model level: `alchy.events <http://alchy.readthedocs.org/en/latest/api.html#module-alchy.events>`_
- Query class integration with SQLAlchemy's `Loader API <http://docs.sqlalchemy.org/en/latest/orm/loading_relationships.html#relationship-loader-api>`_: `alchy.Query <http://alchy.readthedocs.org/en/latest/api.html#module-alchy.query>`_
- Model to dictionary serialization: `alchy.Model.to_dict <http://alchy.readthedocs.org/en/latest/_modules/alchy/model.html#ModelBase.to_dict>`_
- Better model updating with support for nested relationships: `alchy.Model.update <http://alchy.readthedocs.org/en/latest/_modules/alchy/model.html#ModelBase.update>`_
- Numerous base model methods and properties: `alchy.Model <http://alchy.readthedocs.org/en/latest/api.html#module-alchy.model>`_

You can get alchy on `Github <https://github.com/dgilland/alchy>`_ or `PyPI <https://pypi.python.org/pypi/alchy/>`_.
