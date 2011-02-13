Feature: Configuration
  Scenario: Connect to an OpenERP server
    Given i have a configuration file
    When i setup a configuration
    Then i should be able to login
    
  Scenario: Load models
    Given i'm connected to an OpenERP server
    When i load models matching "res.*"
    Then "Oo::Res::Country" should be defined
