Usage
=====

Basics
------
Kangaroo-wrapped OpenObject models provides an ActiveRecord-ish API to find, create and update records.
But please keep in mind, that due to the fundamental differences between a SQL database and the OpenObject
ORM / XML-RPC service. And some things we're saving up for upcoming versions.

### Querying
#### Find
The most basic query method, as in ActiveRecord is {Kangaroo::Model::Finder#find find}, wich reads record(s)
by id(s):

    Oo::Res::Country.find 1
    # => <Oo::Res::Country id: 1 ....>
    
    Oo::Res::Country.find [1, 2]
    # => [<Oo::Res::Country id: 1 ....>, <Oo::Res::Country id: 2 ....>]