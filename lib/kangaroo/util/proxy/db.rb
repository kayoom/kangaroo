module Kangaroo
  module Util
    
    # Proxy to the Db service (at /xmlrpc/db), specifically
    # to those functions, that don't need the superadmin password.
    # You can access this Proxy via your client instance:
    # @example
    #
    #     config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
    #     client = config.client
    #     db_proxy = client.db
    #     db_proxy.list
    #
    # For functions that need superadmin authentication (like create, drop etc)
    # @see Kangaroo::Util::Proxy::Superadmin
    class Proxy::Db < Proxy
      
      # Check if a database exists
      #
      # @param db_name Name of database to check
      # @return [boolean] true if database exists
      def db_exist db_name
        call! :db_exist, db_name
      end

      # Get a list of available databases
      #
      # @return list of databases
      def list
        call! :list
      end

      # Get a list of available languages
      #
      # @return list of languages
      def list_lang
        call! :list_lang
      end

      # Get running server version
      #
      # @return server version
      def server_version
        call! :server_version
      end
    end
  end
end