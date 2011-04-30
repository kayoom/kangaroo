module Kangaroo
  module Util
    
    # Proxy to the Db service (at /xmlrpc/db), specifically
    # to those functions, that need the superadmin password.
    # You can access this Proxy via your client instance:
    # @example
    #
    #     config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
    #     client = config.client
    #     superadmin_proxy = client.superadmin 'admin'
    #     superadmin_proxy.drop 'test_database'
    #
    # For functions that need superadmin authentication (like create, drop etc)
    # @see Kangaroo::Util::Proxy::Superadmin
    class Proxy::Superadmin < Proxy
      # Create a new database
      #
      # @param [String] db_name name for new database
      # @param [boolean] demo preload database with demo data
      # @param [String] lang default language for new database
      # @param [String] password set administrator password for new database
      # @return [Integer] thread id to check progress
      def create db_name, demo, lang, password
        call! :create, db_name, demo, lang, password
      end

      # Check progress on database creation. Pass the id you get
      # from #create as only parameter
      #
      # @param id id from #create
      # @return progress as float between 0.0 and 1.0
      def get_progress id
        call! :get_progress, id
      end

      # Drop a database by name
      #
      # @param db_name name of database to drop
      def drop db_name
        call! :drop, db_name
      end

      # Dump/Backup a database by name
      #
      # @param db_name name of database to backup
      # @return database dump
      def dump db_name
        call! :dump, db_name
      end

      # Load/Restore a database
      #
      # @param db_name name of database to restore to (or create)
      # @param data dump data to load into database
      def restore db_name, data
        call! :restore, db_name, data
      end

      # Rename a database
      #
      # @param old_name database to rename
      # @param new_name new name for database
      def rename old_name, new_name
        call! :rename, old_name, new_name
      end

      # Change superadmin password
      #
      # @param new_password new superadmin password
      # @return true
      def change_admin_password new_password
        call! :change_admin_password, new_password
      end

      # Migrate specified databases
      #
      # @param databases list of databases to migrate
      def migrate_databases databases
        call! :migrate_databases, databases
      end
    end
  end
end