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


#### One2many

This association is the counterpart to [Many2one](#many2one) (obviously). It corresponds to `has_many` in Rails. You can read/write `ids` of associated objects, as well as associated objects themselves. The conventions are similar as with `many2one`.

let
{% highlight ruby %}
partner = Oo::Res::Partner.find 1
{% endhighlight %}

OpenERPs `res.partner` has a one2many association to `res.partner.address`, represented by a field `address`. As with `many2one` associations, Kangaroo leaves this field as it is, and imposes a convention by defining following additional methods.

reading `ids` of associated addresses
{% highlight ruby %}
partner.address
# => [1]
partner.address_ids
# => [1]
{% endhighlight %}

writing `ids` to associate addresses
{% highlight ruby %}
partner.address_ids = [2, 3]
partner.address_ids
# => [2, 3]
{% endhighlight %} 

**but**
{% highlight ruby %}
partner.address
# => [[6, 0, [2, 3]]]
{% endhighlight %}

this may seem strange, but is the way OpenERP works and expects Associations to set. Basically `6` means, *replace all associations*, there are other *modes* for `0, 1, 2, 3, 4, 5`, but those aren't supported yet. 

Here is a list of OpenERP `one2many` *modes* (taken from OpenERP source doc):

    (0, 0,  { values })   link to a new record that needs to be created with the given values 
                          dictionary
    (1, ID, { values })   update the linked record with id = ID (write *values* on it)
    (2, ID)               remove and delete the linked record with id = ID (calls unlink on ID, 
                          that will delete the object completely, and the link to it as well)
    (3, ID)               cut the link to the linked record with id = ID (delete the relationship 
                          between the two objects but does not delete the target object itself)
    (4, ID)               link to existing record with id = ID (adds a relationship)
    (5)                   unlink all (like using (3,ID) for all linked records)
    (6, 0, [IDs])         replace the list of linked IDs (like using (5) then (4,ID) for each 
                          ID in the list of IDs)
    
You can of course use these other modes by setting `address=` directly:

{% highlight ruby %}
partner.address = [[5]] # unlinks all associations
partner.save
partner.address = []
{% endhighlight %}

