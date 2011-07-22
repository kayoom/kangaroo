---
layout: documentation
title: Tools
---

Associations
------------

### Introduction

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

let
{% highlight ruby %}
line = Oo::Sale::Order::Line.first
{% endhighlight %}

default OpenERP behavior
{% highlight ruby %}
# product_id, always returns the field content, exactly as read from OpenERP
line.product_id
# => [4, "[PC2] Basic+ PC (assembly on order)"]
{% endhighlight %}

reading associated `id`
{% highlight ruby %}
# product_id_id returns the single id of the associated object
line.product_id_id
# => 4
{% endhighlight %}

reading associated `name`
{% highlight ruby %}
# product_id_name returns the name of the associated object
line.product_id_name
# => "[PC2] Basic+ PC (assembly on order)"
{% endhighlight %}

reading associated object
{% highlight ruby %}
# product_id_obj returns the associated object itself
line.product_id_obj
# => <Oo::Product::Product id: 4, warranty: 0.0, ..... > 
{% endhighlight %}

writing associated id
{% highlight ruby %}
# product_id_id= sets the association via id
line.product_id_id = Oo::Product::Product.first.id
{% endhighlight %}

writing associated object
{% highlight ruby %}
# product_id_obj= sets the association via an object
line.product_id_obj = Oo::Product::Product.first
{% endhighlight %}
