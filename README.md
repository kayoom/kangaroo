Kangaroo
========

NOTE
----
This branch is NOT functional. We're refactoring big time!

Overview
--------

Kangaroo is an OpenObject client/wrapper for Rails 3, based on ActiveModel. It provides CRUD access to OpenERP objects via XMLRPC.
It's fast, provides default data for new objects and basic validations (for required fields etc), as well as a simple ARel like
query syntax and (not yet fully, but it's coming) associations. This is pre-pre-alpha ;).

Installation
------------

If you're on Rails 3, just add Kangaroo to your Gemfile:

    gem 'kangaroo'

And create a **kangaroo.yml** configuration file in **[RAILS\_ROOT]/config**, containing these options:

    host: 127.0.0.1
    port: 8069

    database:
      name: my_openerp
      user: admin
      password: admin

      models:
        - account.*
        - product.*
        - res.company

Adjust your connection and database settings and specify the models you need.

Usage
-----
