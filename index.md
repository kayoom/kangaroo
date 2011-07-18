---
layout: default
title: Introduction
---

Introduction
============

Overview
--------

Kangaroo is a client for OpenObject / [OpenERP](http://www.openerp.com) XML-RPC interface. It enables you to read/create/update/delete arbitrary models / tables / objects in an OpenERP database, using the OpenObject ORM over XML-RPC. Kangaroo gives you a full ORM for any model, based on ActiveModel and following ActiveRecord conventions. You don't have to learn a new API, as a lot of things already work
exactly as they do with ActiveRecord models, and the rest will follow in future releases.

Quickstart
----------

### CLI

The quickest way to start trying Kangaroo, is probably using the CLI, which provides a ruby console (IRB) to play around.  

First of all, install the gem

{% highlight bash %}
gem install kangaroo
{% endhighlight %}
    
Make sure your OpenERP Server is running and fire up the `kang` CLI

{% highlight bash %}
kang -h localhost -p 8069 -u admin -p admin -d your_erp_db_name
{% endhighlight %}
    
If your server is running on the same machine, and you haven't changed its default ports, you can omit the `-h` server and `-p` port options.

Go ahead, and try some things, like

{% highlight ruby %}
Oo::Res::Country.all
Oo::Product::Product.where(:name => "1984").first
Oo::Res::Partner.order(:name).all
{% endhighlight %}
    
You can access common methods too via `Kang`

{% highlight ruby %}
Kang.common.about
Kang.common.set_loglevel 'superadminpassword', :debug_sql
Kang.common.get_server_environment
Kang.common.get_stats
Kang.db.list
{% endhighlight %}
    
*Note: The constant `Kang` is only available in the CLI*

### Rails

Put the gem in your Gemfile

{% highlight bash %}
gem 'kangaroo'
{% endhighlight %}
    
update your bundle

{% highlight bash %}
bundle install
{% endhighlight %}
  
and create a `kangaroo.yml` in `#{Rails.root}/config/` with

{% highlight yaml %}
host: 127.0.0.1
port: 8069

database:
  name: kangaroo_test_database
  user: admin
  password: admin
{% endhighlight %}
      
Use your OpenERP models anywhere, see [Usage](/usage.html) to see how.
      
### Any other project using Bundler

(missing documentation)

### Any other non-Bundler project

Use Kangaroo in any Ruby project!

{% highlight bash %}
gem install kangaroo
{% endhighlight %}
    
In your code

{% highlight ruby %}
require 'rubygems'
require 'kangaroo'

# Configure a connection to an OpenERP server
config = Kangaroo::Util::Configuration.new yaml_file_or_hash, Logger.new(STDOUT)
config.login

# Load OpenERP models matching "res.*" into namespace ::Oo
# Kangaroo::Util::Loader can be called several times, whenever needed.
Kangaroo::Util::Loader.new('res.*', config.database, 'Oo').load!
{% endhighlight %}
    
First Steps
-----------

OpenObject models are mapped to ruby classes:

{% highlight ruby %}
Oo::Res::Country
# represents 'res.country'

Oo::Product::Product
# represents 'product.product'

Oo::Sale::Order::Line
# represents 'sale.order.line
{% endhighlight %}
    
You can use this models like ActiveRecord models:

{% highlight ruby %}
country = Oo::Res::Country.find 1
country = Oo::Res::Country.where(:code => 'DE').first

country.name = "Schland"
country.save

country.reload

countries = Oo::Res::Country.limit(100).all
countries = Oo::Res::Country.limit(100).order('code').all

Oo::Res::Country.create :code => 'DE', :name => 'Germany'
{% endhighlight %}