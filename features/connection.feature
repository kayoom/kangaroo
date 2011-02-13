Feature: Connection
  Scenario: Connect to an OpenERP server
    Given i have a configuration file
    When i setup a configuration
    Then i should be able to login