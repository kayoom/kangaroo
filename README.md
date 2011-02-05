Kangaroo
========

Kangaroo is an OpenObject client/wrapper for Rails 3, based on ActiveModel. It provides CRUD access to OpenERP objects via XMLRPC.
It's fast, provides default data for new objects and basic validations (for required fields etc), as well as a simple ARel like
query syntax and (not yet fully, but it's coming) associations. This is pre-pre-alpha ;).


Test Environment
----------------

If you want to run Kangaroos Testsuit on your own, you need a running OpenERP server with a test database.
You can find instructions on how to setup the OpenERP server [here](http://doc.openerp.com/v6.0/install/index.html#installation-link).

### Setting up the test database
Use the OpenERP GTK or Web client to create a new database with:

* name: kangaroo\_test\_database
* load demo data: true
* default language: english
* password: admin

Just advance the upcoming configuration wizard and leave everything as it is.

