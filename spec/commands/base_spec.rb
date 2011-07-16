require 'spec_helper'
require 'kangaroo/commands/base'

describe Kangaroo::Commands::Base do
  
  describe 'configuration, called with' do
    let(:argv) { [] }
    subject { described_class.new(*argv).configuration }
  
    context 'with --config file' do
      let(:argv) { %w(--config spec/test_env/test.yml) }
      
      its(['host']) { should == "127.0.0.1" }
      its(['database']) { should include('user' => 'admin')}
      its(['database']) { should include('password' => 'admin')}
      its(['database']) { should include('name' => 'kangaroo_test_database')}
      
      context 'and --host localhost' do
        let(:argv) { %w(--config spec/test_env/test.yml --host localhost) }
        its(['host']) { should == 'localhost'}
      end
    end
    
    context 'short arguments' do
      let(:argv) { %w(-u admin -p admin -d kangaroo_test_database) }
      its(['port']) { should == 8069 }
      its(['host']) { should == "localhost" }
      its(['database']) { should include('user' => 'admin')}
      its(['database']) { should include('password' => 'admin')}
      its(['database']) { should include('name' => 'kangaroo_test_database')}
    end
    
    context 'with --user, --password and --database' do
      let(:argv) { %w(--user admin --password admin --database kangaroo_test_database) }
      its(['port']) { should == 8069 }
      its(['host']) { should == "localhost" }
      its(['database']) { should include('user' => 'admin')}
      its(['database']) { should include('password' => 'admin')}
      its(['database']) { should include('name' => 'kangaroo_test_database')}
    end
  end
end