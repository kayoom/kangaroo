require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Base do
      before :all do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.stub!(:fields_hash).and_return({})
        @klass.define_multiple_accessors :a, :b
      end

      it 'sets attributes on initialization' do
        @klass.stub!(:default_attributes).and_return({})
        @object = @klass.new :a => 'one'
        @object.instance_variable_get('@attributes')['a'].should == 'one'
      end
    end
  end
end