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
    
Additionally the classic keywords for *find* can be used:

    Oo::Res::Country.find :first
    Oo::Res::Country.find :last
    Oo::Res::Country.find :all
    
#### First / All / Last
Shorter than *find(keyword)* are definitely {Kangaroo::Model::Finder#first first}, {Kangaroo::Model::Finder#all all}, {Kangaroo::Model::Finder#last last}:

    Oo::Res::Country.first
    Oo::Res::Country.last
    Oo::Res::Country.all

#### Relation-like querying
Kangaroo somewhat tries to emulate ActiveRecords great ARel query interface, so you can specify
conditions via **where**:

    Oo::Res::Country.where(:code => 'DE').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: 'Germany'>
    
**limit** and **offset**:

    Oo::Res::Country.offset(10).limit(2).all
    # => [<Oo::Res::Country id: 11 ....>, <Oo::Res::Country id: 12 ....>]
    
**context**:

    Oo::Res::Country.context(:lang => 'de_DE').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: 'Deutschland'>
    
read only some fields with **select**:

    Oo::Res::Country.select('code').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: nil>
    
order the results with **order**:

    Oo::Res::Country.order(:name).all
    
    # Or if you wish descending order
    Oo::Res::Country.order(:name, true).all
    
additionally, there is **reverse**, which reverses all prior **order** clauses 
(or adds an **order('id', true)**)

    Oo::Res::Country.reverse.all
    # => [<Oo::Res::Country id: 245 ....>, <Oo::Res::Country id: 244 ....>]