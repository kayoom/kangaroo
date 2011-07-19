---
title: Advanced
layout: default
---

Advanced
========

Architecture
------------

### Components
Kangaroo mainly consists of 3 parts:

*  **Util** contains everything needed to establish and use a connection to an OpenERP server.
   Use `Kangaroo::Util::Configuration` to configure a connection to a database, and
   `Kangaroo::Util::Loader` to load the models you need.
*  **RubyAdapyer** is a mini-framework to convert OpenObject models to ruby. It's responsible 
   of creating the neccessary modules and classes to use i.e. the "product.product" model
   via `Oo::Product::Product`
*  **Model** is the base class for all OpenObject models, and is responsible for all runtime
   behavior.
    


### Communication
Communication with OpenERP happens on different levels.

#### Proxies
The lowest level of communication happens over `Kangaroo::Util::Proxy` and its subclasses. They
proxy method calls to the XML-RPC services the OpenERP server provides. Kangaroo utilizes [rapuncel](http://rubygems.org/gems/rapuncel) as XML-RPC middleware.

#### OpenObject Wrapping
The next level are OpenObject wrapper classes, which are automatically generated for your OpenERP models. Naming of these wrapper classes follows a strict convention, a few examples:

{% highlight ruby %}
Oo::Res::Company.oo_name
# => "res.company"

Oo::Product::Product.oo_name
# => "product.product"

Oo::Sale::Order.oo_name
# => "sale.order"

Oo::Sale::Order::Line.oo_name
# => "sale.order.line"
{% endhighlight %}

#### OpenObject ORM

Suppose you have a Ruby model for an OpenObject model `Oo::Res::Country` (either via directly subclassing `Kangaroo::Model::Base`, or via `Kangaroo::Util::Loader`), you can access the OpenObject ORM API directly:

{% highlight ruby %}
Oo::Res::Country.search(...)
Oo::Res::Country.read(...)
Oo::Res::Country.fields_get(...)
Oo::Res::Country.default_get(...)
Oo::Res::Country.unlink(...)
{% endhighlight %}
    
The **create** and **write** commands are named **create\_record** and **write\_record**

{% highlight ruby %}
Oo::Res::Country.create_record(...)
Oo::Res::Country.write_record(...)
{% endhighlight %}
    
#### ActiveRecord-ish / ActiveModel ORM

On top of the [OpenObject ORM](#openobject_orm) Kangaroo provides a layer, which provides an API similar to ActiveRecord. You can find, read, search, create, update and destroy objects, as well as use validations and callbacks. 

e.g.
{% highlight ruby %}
Oo::Res::Country.all
Oo::Product::Product.where(:name => "1984").first
{% endhighlight %}

### Associations

#### Introduction

Associations in OpenERP don't follow as strict conventions as they do in Rails, so Kangaroo tries to create a convention, which may be a bit ugly, but is easy to remember and still gives you the chance to work around it, if you need special OpenERP features not yet supported by Kangaroo. 

Basically Kangaroo just adds suffixes to the fields returned from OpenERP to support associations properly. Best way to explain are examples.

#### Many2One

This is probably the simplest association type, and corresponds to `belongs_to` in Rails. Let's take `Oo::Sale::Order::Line` as an example. `Oo::Sale::Order::Line` has a `many2one` association to `Oo::Product::Product`, referenced by a foreign key `product_id`. Now, OpenERP does return 2 different values for `product_id`, depending how it's queried.

* From inside OpenERP-Server with `sale_order_line#browse`, `product_id` returns a browsable object
* From inside OpenERP-Server with `sale_order_line#read` and via XML-RPC `product_id` returns a tuple/Array
  containing the foreign id and the name of the associated object.
  
So

{% highlight ruby %}
Oo::Sale::Order::Line.first.product_id
# => [4, "[PC2] Basic+ PC (assembly on order)"]
{% endhighlight %}

unfortunately, setting doesn't work the same way, as OpenERP expects a single integer for `product_id=()`,
which is a bit asymmetrical. To counteract this, Kangaroo imposes following conventions:

{% highlight ruby %}
line = Oo::Sale::Order::Line.first

# product_id, always returns the field content, exactly as read from OpenERP
line.product_id
# => [4, "[PC2] Basic+ PC (assembly on order)"]

# product_id_id returns the single id of the associated object
line.product_id_id
# => 4

# product_id_name returns the name of the associated object
line.product_id_name
# => "[PC2] Basic+ PC (assembly on order)"

# product_id_obj returns the associated object itself
line.product_id_obj
# => <Oo::Product::Product id: 4, warranty: 0.0, ..... > 

# product_id_id= sets the association via id
line.product_id_id = Oo::Product::Product.first.id

# product_id_obj= sets the association via an object
line.product_id_obj = Oo::Product::Product.first
{% endhighlight %}