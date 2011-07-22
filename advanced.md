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

