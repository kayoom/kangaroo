require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Inspector do
      before :all do
        SomeClass = Class.new(Kangaroo::Model::Base)
        SomeClass.define_multiple_accessors :first_attribute, :second_attribute
      end

      before :each do
        SomeClass.stub!(:default_attributes).and_return({})
      end

      context 'Class#inspect' do
        it 'includes attribute names' do
          SomeClass.inspect.should include('first_attribute')
          SomeClass.inspect.should include('second_attribute')
        end

        it 'includes class name' do
          SomeClass.inspect.should include('SomeClass')
        end

        it 'includes id' do
          SomeClass.inspect.should include('id')
        end
      end

      context 'Object#inspect' do
        before :each do
          @object = SomeClass.new :first_attribute => 'one', :second_attribute => 'two'
        end

        it 'includes attribute names and values' do
          @object.inspect.should include('first_attribute: "one"')
          @object.inspect.should include('second_attribute: "two"')
        end

        it 'includes class name' do
          @object.inspect.should include('SomeClass')
        end

        it 'includes id' do
          @object.instance_variable_set '@id', 3
          @object.inspect.should include('id: 3')
        end

        it 'includes id: nil on new records' do
          @object.inspect.should include('id: nil')
        end
      end
    end
  end
end