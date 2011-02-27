require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/loader'

module Kangaroo
  module Util
    describe Loader do
      # include TestServerHelper

      def config_file
        File.join File.dirname(__FILE__), '..', 'test_env', 'test.yml'
      end

      it "replaces wildcards in model names" do
        loader = Loader.new ['res.*'], nil

        loader.model_names.should == ['res.%']
      end

      it "uses global wildcard if model_names = :all" do
        loader = Loader.new :all, nil

        loader.model_names.should == ['%']
      end

      it 'raises error if model_names = nil or empty' do
        lambda { Loader.new nil, nil }.should raise_error
        lambda { Loader.new [], nil }.should raise_error
      end

    end
  end
end
