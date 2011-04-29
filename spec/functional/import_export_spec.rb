require 'spec_helper'

module Kangaroo
  describe 'Import / Export' do
    before :all do
      @config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      @config.login
  
      Kangaroo::Util::Loader.new('res.partner', @config.database, 'ImportExportSpec').load!
    end
    
    it 'exports records' do
      ids = ImportExportSpec::Res::Partner.select(:id).limit(3).all.map &:id
      
      exported = ImportExportSpec::Res::Partner.export_data ids, [:name, :id]
      
      exported.should be_a(Array)
      exported.first.should be_a(Array)
      exported.first.length.should == 2
    end
    
    it 'imports records' do
      id = ImportExportSpec::Res::Partner.first.id
      
      ImportExportSpec::Res::Partner.import_data [".id", "name"], [[id, "XYZ"]]
      ImportExportSpec::Res::Partner.find(id).name.should == "XYZ"
    end
  end
end