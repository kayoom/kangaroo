---
layout: documentation
title: Usage
---

Usage
=====

Installation
------------

See [Introduction](/index.html) for information, how to install Kangaroo.

Basics
------

Kangaroo-wrapped OpenObject models provides an ActiveRecord-ish API to find, create and update records.
But please keep in mind, that due to the fundamental differences between a SQL database and the OpenObject
ORM / XML-RPC service, not everything works exactly the same. And some things we're saving up for upcoming versions.

### Querying
#### Find
The most basic query method, as in ActiveRecord is `find`, wich reads record(s) by id(s)

{% highlight ruby %}
Oo::Res::Country.find 1
# => <Oo::Res::Country id: 1 ....>

Oo::Res::Country.find [1, 2]
# => [<Oo::Res::Country id: 1 ....>, <Oo::Res::Country id: 2 ....>]
{% endhighlight %}
    
Additionally the classic keywords for `find` can be used:

{% highlight ruby %}
Oo::Res::Country.find :first
Oo::Res::Country.find :last
Oo::Res::Country.find :all
{% endhighlight %}
    
#### First / All / Last
Shorter than `find(keyword)` are definitely `first`, `all` and `last`

{% highlight ruby %}
Oo::Res::Country.first
Oo::Res::Country.last
Oo::Res::Country.all
{% endhighlight %}

#### Relation-like querying
Kangaroo somewhat tries to emulate ActiveRecords great ARel query interface, so you can specify conditions via `where`

{% highlight ruby %}
Oo::Res::Country.where(:code => 'DE').first
# => <Oo::Res::Country id: 42, code: 'DE', name: 'Germany'>
{% endhighlight %}
    
`limit` and `offset`

{% highlight ruby %}
Oo::Res::Country.offset(10).limit(2).all
# => [<Oo::Res::Country id: 11 ....>, <Oo::Res::Country id: 12 ....>]
{% endhighlight %}
    
`context` (context is a Hash used in OpenERP to pass additional options for a query, e.g. which translation to fetch)

{% highlight ruby %}
Oo::Res::Country.context(:lang => 'de_DE').first
# => <Oo::Res::Country id: 42, code: 'DE', name: 'Deutschland'>
{% endhighlight %}
    
read only some fields with `select`

{% highlight ruby %}
Oo::Res::Country.select('code').first
# => <Oo::Res::Country id: 42, code: 'DE', name: nil>
{% endhighlight %}
    
order the results with `order`

{% highlight ruby %}
Oo::Res::Country.order(:name).all

# Or if you wish descending order
Oo::Res::Country.order(:name, true).all
{% endhighlight %}

#### A note about `where`
The OpenObject ORM expects conditions as an Array like this

{% highlight ruby %}
Oo::Res::Country.where(['code', '=', 'DE']).first
{% endhighlight %}
    
As this can be quite cumbersome to use, Kangaroo accepts conditions as Strings, which will simply be
splitted in an Array

{% highlight ruby %}
Oo::Res::Country.where('a = one').first
{% endhighlight %}  

This implies that you can't specify complex conditions via Strings, this is only to simplify simple conditions.  
As shown before, also Hash conditions work:

{% highlight ruby %}
Oo::Res::Country.where(:code => 'DE').first

# Or if you use an Array Kangaroo will switch to the **in** operator
Oo::Res::Country.where(:code => ['DE', 'EN']).all 
{% endhighlight %}    
    
### Working with records
#### Attributes
All OpenObject fields are accessible via getters and setters:

{% highlight ruby %}
record = Oo::Res::Country.where(:code => 'DE').first
record.name
# => "Germany"

record.name = "Dschoermany"
record.name
# => "Dschoermany"
{% endhighlight %}
    
Of course those attributes can be persisted

{% highlight ruby %}
record.save
record.reload
record.name
# => "Dschoermany"
{% endhighlight %}
    
    
#### Dirty
Kangaroo includes `ActiveModel::Dirty` to keep track of changes:

{% highlight ruby %}
record = Oo::Res::Country.where(:code => 'DE').first
record.name
# => "Germany"

record.name = "Dschoermany"
record.changed?
# => true

record.name_was
# => "Germany"
{% endhighlight %}    
    
#### Creating records
If you initialize a new record, Kangaroo fetches the default values for this model

{% highlight ruby %}
record = Oo::Res::User.new
record.context_lang
# => 'en_US'
record.context_lang_changed?
# => true
{% endhighlight %}

#### Destroying records

{% highlight ruby %}
Oo::Res::User.first.destroy
{% endhighlight %}
    
    
### Misc
#### new\_record? / persisted? / destroyed?

Kangaroo also supports `new_record?` and `persisted?`

{% highlight ruby %}
record = Oo::Res::User.new
record.new_record?
# => true

record.persisted?
# => false    
{% endhighlight %}
    
as well as `destroyed?`

{% highlight ruby %}
record = Oo::Res::Country.first
record.destroy
record.destroyed?
# => true
{% endhighlight %}
    
#### Lazy model loading

You don't have to specify all models you ever need in your configuration file. Kangaroo will lazy load
models as they are accessed:

{% highlight ruby %}
Oo.const_defined? "Product"
# => false 
Oo::Product
# => Module 'Oo::Product' contains loaded OpenERP Models/Namespaces:  
Oo::Product.const_defined? "Product"
# => false 
Oo::Product::Product
# => <Oo::Product::Product id, .... > 
{% endhighlight %}
