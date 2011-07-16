Kangaroo
========

Overview
--------

Kangaroo is an OpenObject client/wrapper for Ruby, based on ActiveModel. It provides CRUD access to OpenERP objects via XMLRPC.
It's fast and provides a lot of neat features.

Documentation and Feedback
--------------------------

Please give us some feedback especially on the documentation, which surely requires a lot of work.

Quick Start
-----------

    gem install kangaroo
    
    kang -u admin -p admin -d some_database
    > Oo::Res::Country.limit(5).order(:name).all
    # +------+-----------------------------+
    # | code | name                        |
    # +------+-----------------------------+
    # | DZ   | Algeria                     |
    # | AS   | American Samoa              |
    # | AD   | Andorra, Principality of    |
    # | AO   | Angola                      |
    # | AI   | Anguilla                    |
    # +------+-----------------------------+

    
[a lot more here](http://kangaroogem.org)

Development
-----------

Homepage:
[http://kangaroogem.org](http://kangaroogem.org)

SCM:
[https://github.com/cice/kangARoo](https://github.com/cice/kangARoo)

Issues:
[http://github.com/cice/kangARoo/issues](http://github.com/cice/kangARoo/issues)

Rubygems:
[https://rubygems.org/gems/kangaroo](https://rubygems.org/gems/kangaroo)