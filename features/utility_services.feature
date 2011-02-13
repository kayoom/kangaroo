Feature: Utility Services
  Scenario: Get server information
    Given i'm connected to an OpenERP server
    And setup a proxy to "common"
    When i call common.about
    Then i should see "OpenERP"
    
  Scenario: Get server environment
    Given i'm connected to an OpenERP server
    And setup a proxy to "common"
    When i call common.get_server_environment
    Then i should see "OpenERP-Server Version : 6"
    And i should see "Python Version : 2.6"
    
  Scenario: Get server stats
    Given i'm connected to an OpenERP server
    And setup a proxy to "common"
    When i call common.get_stats
    Then i should see "HTTPd: running"
    
  Scenario: List available HTTP services
    Given i'm connected to an OpenERP server
    And setup a proxy to "common"
    When i call common.list_http_services
    Then the list should include "service.http_server.XMLRPCRequestHandler"
    
  Scenario: List available databases
    Given i'm connected to an OpenERP server
    And setup a proxy to "db"
    When i call db.list
    Then the list should include "kangaroo_test_database"
    
  Scenario: List available languages
    Given i'm connected to an OpenERP server
    And setup a proxy to "db"
    When i call db.list_lang
    Then the list should include "English"
    
  