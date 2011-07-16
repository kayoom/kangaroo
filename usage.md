---
layout: default
title: Usage
---

Usage
=====

Table Of Contents
-----------------

1. [Installation](#installation)
2. [Basics](#basics)

   1. [Querying](#querying)
  
      1. [Find](#find)
      2. [First / All / Last](#first__all__last)
      3. [Relation-like querying](#relationlike_querying)
      4. [A note about where](#a_note_about_)
      
   2. [Working with records](#working_with_records)
      1. [Attributes](#attributes)
      2. [Dirty](#dirty)
      3. [Creating records](#creating_records)
      4. [Destroying records](#destroying_records)
      5. [Misc](#misc)

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

    Oo::Res::Country.find 1
    # => <Oo::Res::Country id: 1 ....>
    
    Oo::Res::Country.find [1, 2]
    # => [<Oo::Res::Country id: 1 ....>, <Oo::Res::Country id: 2 ....>]
    
Additionally the classic keywords for `find` can be used:

    Oo::Res::Country.find :first
    Oo::Res::Country.find :last
    Oo::Res::Country.find :all
    
#### First / All / Last
Shorter than `find(keyword)` are definitely `first`, `all` and `last`

    Oo::Res::Country.first
    Oo::Res::Country.last
    Oo::Res::Country.all

#### Relation-like querying
Kangaroo somewhat tries to emulate ActiveRecords great ARel query interface, so you can specify conditions via `where`

    Oo::Res::Country.where(:code => 'DE').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: 'Germany'>
    
`limit` and `offset`

    Oo::Res::Country.offset(10).limit(2).all
    # => [<Oo::Res::Country id: 11 ....>, <Oo::Res::Country id: 12 ....>]
    
`context` (context is a Hash used in OpenERP to pass additional options for a query, e.g. which translation to fetch)

    Oo::Res::Country.context(:lang => 'de_DE').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: 'Deutschland'>
    
read only some fields with `select`

    Oo::Res::Country.select('code').first
    # => <Oo::Res::Country id: 42, code: 'DE', name: nil>
    
order the results with `order`

    Oo::Res::Country.order(:name).all
    
    # Or if you wish descending order
    Oo::Res::Country.order(:name, true).all

#### A note about `where`
The OpenObject ORM expects conditions as an Array like this

    Oo::Res::Country.where(['code', '=', 'DE']).first
    
As this can be quite cumbersome to use, Kangaroo accepts conditions as Strings, which will simply be
splitted in an Array

    Oo::Res::Country.where('a = one').first
    
This implies that you can't specify complex conditions via Strings, this is only to simplify simple conditions.  
As shown before, also Hash conditions work:

    Oo::Res::Country.where(:code => 'DE').first
    
    # Or if you use an Array Kangaroo will switch to the **in** operator
    Oo::Res::Country.where(:code => ['DE', 'EN']).all 
    
    
### Working with records
#### Attributes
All OpenObject fields are accessible via getters and setters:

    record = Oo::Res::Country.where(:code => 'DE').first
    record.name
    # => "Germany"

    record.name = "Dschoermany"
    record.name
    # => "Dschoermany"
    
Of course those attributes can be persisted

    record.save
    record.reload
    record.name
    # => "Dschoermany"
    
#### Dirty
Kangaroo includes `ActiveModel::Dirty` to keep track of changes:

    record = Oo::Res::Country.where(:code => 'DE').first
    record.name
    # => "Germany"

    record.name = "Dschoermany"
    record.changed?
    # => true
    
    record.name_was
    # => "Germany"
    
#### Creating records
If you initialize a new record, Kangaroo fetches the default values for this model

    record = Oo::Res::User.new
    record.context_lang
    # => 'en_US'
    record.context_lang_changed?
    # => true

#### Destroying records

    Oo::Res::User.first.destroy
    
    
#### Misc
Kangaroo also supports `new_record?` and `persisted?`

    record = Oo::Res::User.new
    record.new_record?
    # => true
    
    record.persisted?
    # => false
    
as well as `destroyed?`

    record = Oo::Res::Country.first
    record.destroy
    record.destroyed?
    # => true

    
