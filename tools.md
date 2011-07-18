---
layout: documentation
title: Tools
---

Usage
=====

Tools
-----

### Command Line Interface

#### Ruby Console

Kangaroo comes with a handy console, based on `IRB` to examine your OpenERP database or perform quick tasks.

Just fire it up with

{% highlight bash %}
kang --user admin --password admin --database kangaroo_test_database
{% endhighlight %}

and use it like `IRB`

{% highlight ruby %}
Oo::Res::Country.offset(10).limit(2).all
# => [<Oo::Res::Country id: 11 ....>, <Oo::Res::Country id: 12 ....>]
{% endhighlight %}

Use `kang --help` for more information on possible options.
{% highlight man %}
kang - The Kangaroo command line interface

Usage:
        --help                       Display this help screen
    -c, --config FILE                Specify a configuration file
    -u, --user USER                  Set user to use to login to OpenERP, must be a valid 
                                     OpenERP user with sufficient privileges
    -p, --password PASSWORD          Set password for user
    -h, --host HOST                  Set hostname (default: localhost)
    -i, --port PORT                  Set port (default: 8069)
    -d, --database DATABASE          Set name of database to use
    -n, --namespace NAMESPACE        Set namespace / root module to use for models (default: Oo)
    -m, --models MODELS              Set models to load eagerly, separate with : 
                                     (e.g. res.*:product.product:sale.* 
                                     or "all" to load everything)
{% endhighlight %}

#### Generate Documentation

You can generate a YARD documentation exactly for your database, including your own modules and modifications with `kangdoc`.
`kangdoc` expects the same arguments as `kang`. You can see a demo of the documentation generated for my `kangaroo_test_database` here:
[Kangaroo Documentation Demo](http://demo.kangaroogem.org).