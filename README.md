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


Lazy model loading
------------------

You don't have to specify all models you ever need in your configuration file. Kangaroo will lazy load
models as they are accessed:

    ruby-1.8.7-p302 :001 > Oo.const_defined? "Product"
     => false 
    ruby-1.8.7-p302 :002 > Oo::Product
     => Module 'Oo::Product' contains loaded OpenERP Models/Namespaces:  
    ruby-1.8.7-p302 :003 > Oo::Product.const_defined? "Product"
     => false 
    ruby-1.8.7-p302 :004 > Oo::Product::Product
     => <Oo::Product::Product id, loc_case, volume, type, uos_coeff, incoming_qty, price_margin, sale_ok, loc_rack, description_purchase, code, ean13, warranty, description_sale, outgoing_qty, product_tmpl_id, standard_price, rental, uom_po_id, default_code, supply_method, categ_id, procure_method, virtual_available, variants, packaging, pricelist_id, name_template, uos_id, lst_price, cost_method, description, seller_delay, price_extra, seller_id, price, active, company_id, qty_available, list_price, produce_delay, partner_ref, state, name, purchase_ok, mes_type, sale_delay, weight_net, seller_qty, weight, seller_ids, loc_row, product_manager, uom_id> 
    
Please refer to {file:docs/Usage.md Usage} to learn about limitations/features not yet
implemented.