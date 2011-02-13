module Kangaroo
  module Util
    class Proxy::Common < Proxy
      # Login to an OpenERP database
      #
      # @param [String] db_name The database to log in
      # @param [String] user Username
      # @param [String] password Password
      def login db_name, user, password
        call! :login, db_name, user, password
      end

      # Get information about the OpenERP Server
      #
      # @param [boolean] extended Display extended information
      # @return About information
      def about extended = false
        call! :about, extended
      end

      # Get OpenERP Servers timezone configuration
      #
      # @param database
      # @param login
      # @param password
      # @return Timezone information
      def timezone_get database, login, password
        call! :timezone_get, database, login, password
      end

      # Get server environment
      #
      # @return Details about server environment
      def get_server_environment
        call! :get_server_environment
      end

      # Get login message
      #
      # @return login message
      def login_message
        call! :login_message
      end

      # Set log level
      #
      # @param super_password Superadmin password
      # @param loglevel Loglevel to set
      # @return true
      def set_loglevel super_password, loglevel
        call! :set_loglevel, loglevel.upcase
      end

      # Get server stats
      #
      # @return Server stats
      def get_stats
        call! :get_stats
      end

      # List HTTP services
      #
      # @return List of HTTP services
      def list_http_services
        call! :list_http_services
      end

      # Check connectivity
      #
      # @return [boolean] true/false
      def check_connectivity
        call! :check_connectivity
      end

      # Get servers OS time
      #
      # @param [String] super_password Superadmin password
      # @return servers OS time
      def get_os_time super_password
        call! :get_os_time, super_password
      end

      # Get SQL count, needs loglevel DEBUG_SQL
      #
      # @return Count of SQL queries
      def get_sqlcount
        call! :get_sqlcount
      end

      # Get list of available updates, needs valid Publisher's Warranty
      #
      # @param super_password Superadmin password
      # @param contract_id Publisher's Warranty ID
      # @param contract_password Publisher's Warranty Password
      # @return list of available updates
      def get_available_updates super_password, contract_id, contract_password
        call! :get_available_updates, contract_id, contract_password
      end

      # Get migration scripts, needs valid Publisher's Warranty
      #
      # @param super_password Superadmin password
      # @param contract_id Publisher's Warranty ID
      # @param contract_password Publisher's Warranty Password
      # @return migration scripts
      def get_migration_scripts super_password, contract_id, contract_password
        call! :get_migration_scripts, contract_id, contract_password
      end
    end
  end
end