module Kangaroo
  module Util
    class DbProxy < Proxy
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