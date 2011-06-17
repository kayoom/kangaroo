require 'spec_helper'

module Kangaroo
  describe Model::DataImport do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.country', config.database, 'DataImportSpec').load!
    end
    
    after :each do
      @cleanup && @cleanup.call
    end
    
    it 'updates records' do
      a = DataImportSpec::Res::Country.find 1
      
      old_name = a.name
      @cleanup = lambda do
        a = DataImportSpec::Res::Country.find 1
        a.name = old_name
        a.save!
      end
      a.name = 'abcdefg'
      
      old_count = DataImportSpec::Res::Country.count
      DataImportSpec::Res::Country.import_all [a]
      DataImportSpec::Res::Country.count.should == old_count
      
      DataImportSpec::Res::Country.find(1).name.should == 'abcdefg'
    end
    
    it 'creates new records' do
      a = DataImportSpec::Res::Country.new :code => 'XY', :name => 'a_new_country'
      
      @cleanup = lambda do
        DataImportSpec::Res::Country.where(:code => 'XY').first.destroy
      end
      
      old_count = DataImportSpec::Res::Country.count
      puts DataImportSpec::Res::Country.import_all([a]).inspect
      DataImportSpec::Res::Country.count.should == old_count + 1
      
      DataImportSpec::Res::Country.where(:code => 'XY').first.name.should == 'a_new_country'
    end
  end
end