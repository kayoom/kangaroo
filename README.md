Kangaroo
========

Overview
--------

Kangaroo is an OpenObject client/wrapper for Rails 3, based on ActiveModel. It provides CRUD access to OpenERP objects via XMLRPC.
It's fast and provides default data for new objects.

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

OpenObject models are mapped to ruby classes:

    Oo::Res::Country
    # represents 'res.country'
    
    Oo::Product::Product
    # represents 'product.product'
    
    Oo::Sale::Order::Line
    # represents 'sale.order.line
    
You can use this models like ActiveRecord models:

    country = Oo::Res::Country.find 1
    country = Oo::Res::Country.where(:code => 'DE').first
    
    country.name = "Schland"
    country.save
    
    country.reload
    
    countries = Oo::Res::Country.limit(100).all
    countries = Oo::Res::Country.limit(100).order('code').all
    
    Oo::Res::Country.create :code => 'DE', :name => 'Germany'
    
etc.
Please refer to {file:docs/Usage.md Usage} to learn about limitations/features not yet
implemented.