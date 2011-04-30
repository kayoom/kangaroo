Installation
=====

#### Index
{file:README.md Readme}
{file:docs/Installation.md Installation}
{file:docs/Usage.md Usage}
{file:docs/Architecture.md Architecture}
{file:docs/AdditionalServices.md Additional Services}
{file:docs/Classes.md Classes}

Rails 3
-------
If you're on Rails 3, just add Kangaroo to your Gemfile:

    gem 'kangaroo'
    
And run
    
    bundle install

Create a **kangaroo.yml** configuration file in **[RAILS\_ROOT]/config**, containing these options:

    host: 127.0.0.1
    port: 8069

    database:
      name: my_openerp
      user: admin
      password: admin

      models:
        - account.*
        - product.*
        - res.company

Adjust your connection and database settings, specify the models you wish to get loaded, and you're good to go!
Checkout the usage doc {file:docs/Usage.md Usage}

General Ruby
------------
Install the gem via

    gem install kangaroo
    
Now you need to configure Kangaroo. You can either use a YAML configuration file (see **Rails 3**) or
pass a Hash with configuration options.  
  
via file

    config = Kangaroo::Util::Configuration.new 'some_config_file.yml'
    config.load_models
    
    
via Hash

    config_hash = {
      :host => 'localhost',
      :port => 8069,
      
      :database => {
        :name => 'my_openerp',
        :user => 'admin',
        :password => 'admin',
        
        :models => %w(account.* product.* res.company)
      }
    }
    
    config = Kangaroo::Util::Configuration.new config_hash
    config.load_models

The connection should be setup now, and the models ready to use.

