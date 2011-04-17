require 'spec_helper'

module Kangaroo
  module Model
    describe Validations do
      before :all do
        config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
        config.login
  
        Kangaroo::Util::Loader.new('res.partner', config.database, 'ValidationsSpec').load!
      end
      
      it "validates presence of required attributes" do
        
      end
      
      it 'doesnt validate required attributes if its not required for current state'
      
      
    end
  end
end