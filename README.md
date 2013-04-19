Ohm::IdentityMap
================

Provides a basic identity map for [Ohm][1].

Usage
-----

    require "ohm/identity_map"

    # By default, no identity map is used.

    Post[1].object_id == Post[1].object_id
    # => false

    # Enable the identity map for the duration of a block.

    Ohm::Model.identity_map do
      Post[1].object_id == Post[1].object_id
    end
    # => true

Web
---

It's easy to create a Rack middleware to enable the identity map for the
duration of the request/response cycle. (Such middleware may be included in
this library in the future, once we test this behavior in production.)

    class OhmIdentityMapMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        Ohm::Model.identity_map { @app.call(env) }
      end
    end

    # config.ru or any Rack::Builder
    use OhmIdentityMapMiddleware

Known issues
------------

Currently not handling updates and deletes.

License
-------

See `UNLICENSE`. With love, from [Educabilia](http://educabilia.com).

[1]: https://github.com/soveran/ohm
