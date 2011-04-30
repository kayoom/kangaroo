Architecture
============

#### Index
{file:README.md Readme}
{file:docs/Installation.md Installation}
{file:docs/Usage.md Usage}
{file:docs/Architecture.md Architecture}
{file:docs/AdditionalServices.md Additional Services}
{file:docs/Classes.md Classes}


Components
----------
Kangaroo mainly consists of 3 parts:

  * **Util** contains everything needed to establish and use a connection to an OpenERP server.
    Use {Kangaroo::Util::Configuration} to configure a connection to a database, and
    {Kangaroo::Util::Loader} to load the models you need.
  * **RubyAdapyer** is a mini-framework to convert OpenObject models to ruby. It's responsible 
    of creating the neccessary modules and classes to use i.e. the "product.product" model
    via Oo::Product::Product
  * **Model** is the base class for all OpenObject models, and is responsible for all runtime
    behavior.
    


Communication
-------------

### Proxies
The lowest level of communication happens over {Kangaroo::Util::Proxy} and its subclasses. They
proxy method calls to the XML-RPC services the OpenERP server provides.

### OpenObject ORM
Suppose you have a Ruby model for an OpenObject model **Oo::Res::Country** (either via directly subclassing {Kangaroo::Model::Base},
or via {Kangaroo::Util::Loader}), you can access the OpenObject ORM API directly:

    Oo::Res::Country.search(...)
    Oo::Res::Country.read(...)
    Oo::Res::Country.fields_get(...)
    Oo::Res::Country.default_get(...)
    Oo::Res::Country.unlink(...)
    
The **create** and **write** are named **create\_record** and **write\_record**

    Oo::Res::Country.create_record(...)
    Oo::Res::Country.write_record(...)
    
### ActiveRecord-ish ORM
see {file:docs/Usage.md Usage}