.. title: New Project: pushjack
.. slug: new-project-pushjack
.. date: 2015-04-02 19:06:08 UTC-04:00
.. tags: python, pushjack
.. category:
.. link:
.. description:
.. type: text
.. author: Derrick Gilland


I've started a new Python project: `pushjack <https://github.com/dgilland/pushjack>`_

The goal of pushjack is to provide a basic set of tools for sending push notifications over the APNS (Apple) or GCM (Android) networks.

While there are already several other push notification libraries, I wanted pushjack to be have the following features:


.. TEASER_END


- No dependency on other frameworks or services (e.g. not dependent on Django or Flask or some HTTP API).
- Low level interface that can be wrapped inside a more complex implementation (e.g. using pushjack in a multithreaded, multiprocessed, or asyncio environment).
- High level client interface built on top of the low level modules to provide enhanced functionality.


Current Release
---------------

As of this writing, pushjack is at `v0.3.0 <https://github.com/dgilland/pushjack/tree/v0.3.0>`_ with `98% test coverage <https://coveralls.io/r/dgilland/pushjack>`_.


Sample Usage
------------

Using pushjack is simple:

.. code-block:: python

    from pushjack import APNSClient, create_apns_config

    config = create_apns_config({
        'APNS_CERTIFICATE': '<path/to/certificate.pem>'
    })

    client = APNSClient(config)

    token = '<device token>'
    alert = 'Hello world.'

    # Send to single device.
    # Keyword arguments are optional.
    client.send(token,
                alert,
                badge='badge count',
                sound='sound to play',
                category='category',
                content_available=True,
                title='Title',
                title_loc_key='t_loc_key',
                title_loc_args='loc_args',
                action_loc_key='a_loc_key',
                loc_key='loc_key',
                launch_image='path/to/image.jpg',
                extra={'custom': 'data'})

    # Send to multiple devices.
    # Accepts the same keyword arguments as send().
    client.send_bulk(tokens, alert, **options)

    # Get expired tokens.
    expired = client.get_expired_tokens()

You can find more details and examples on the `documentation site <http://pushjack.readthedocs.org/>`_.


Looking Ahead
-------------

Active development is underway with the goal of releasing ``v1.0.0`` soon to lock in a stable API. You can track or contribute to pushjack on `Github <https://github.com/dgilland/pushjack>`_.
