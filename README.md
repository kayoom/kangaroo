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
    
CLI
---

Kangaroo comes with a console based on IRB, try it:
    
    $kang -c spec/test_env/test.yml 
    I, [2011-04-15T23:19:41.990623 #6834]  INFO -- : Loading Kangaroo configuration "spec/test_env/test.yml"
    I, [2011-04-15T23:19:41.991091 #6834]  INFO -- : Configured OpenERP database "kangaroo_test_database" at "127.0.0.1"
    I, [2011-04-15T23:19:41.996197 #6834]  INFO -- : Authenticated user "admin" for OpenERP database "kangaroo_test_database"
    ruby-1.8.7-p302 :001 > Oo::Res::Country
     => <Oo::Res::Country id, name, code> 
    ruby-1.8.7-p302 :002 > Oo::Res::Country.first
    +---------+------+
    | name    | code |
    +---------+------+
    | Algeria | DZ   |
    +---------+------+
    1 row in set
    
If you omit the -c command line option, you can initialize your Kangaroo connection from the
console:

    $kang
    ruby-1.8.7-p302 :001 > Kang.init "port"=>8069, "database"=>{"name"=>"kangaroo_test_database", "models"=>["res.*"], "password"=>"admin", "user"=>"admin"}, "host"=>"127.0.0.1"
    I, [2011-04-15T23:23:59.789551 #7017]  INFO -- : Loading Kangaroo configuration {"port"=>8069, "database"=>{"name"=>"kangaroo_test_database", "models"=>["res.*"], "user"=>"admin", "password"=>"admin"}, "host"=>"127.0.0.1"}
    I, [2011-04-15T23:23:59.789706 #7017]  INFO -- : Configured OpenERP database "kangaroo_test_database" at "127.0.0.1"
    I, [2011-04-15T23:23:59.794861 #7017]  INFO -- : Authenticated user "admin" for OpenERP database "kangaroo_test_database"
     => true 
    ruby-1.8.7-p302 :002 > Oo::Res::Country.limit(5).all
    +------+-----------------------------+
    | code | name                        |
    +------+-----------------------------+
    | DZ   | Algeria                     |
    | AS   | American Samoa              |
    | AD   | Andorra, Principality ofä ß |
    | AO   | Angola                      |
    | AI   | Anguilla                    |
    +------+-----------------------------+
    5 rows in set

    
etc.
Please refer to {file:docs/Usage.md Usage} to learn about limitations/features not yet
implemented.