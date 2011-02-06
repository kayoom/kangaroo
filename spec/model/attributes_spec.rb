require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Attributes do
      before :all do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.define_multiple_accessors :a, :b
      end
      
      before :each do
        @klass.stub!(:default_attributes).and_return({})
      end
      
      it 'allows to read attributes via read_attribute' do
        @object = @klass.new :a => 'one'
        @object.read_attribute(:a).should == 'one'
      end
      
      it 'allows to read attributes via getters' do
        @object = @klass.new :a => 'one'
        @object.a.should == 'one'
      end
      
      it 'allows to write attributes via write_attribute' do
        @object = @klass.new :a => 'one'
        @object.write_attribute :a, 'two'
        @object.a.should == 'two'
      end
      
      it 'allows to write attributes via setters' do
        @object = @klass.new :a => 'one'
        @object.a = 'two'
        @object.a.should == 'two'
      end

      it 'allows to mass assign attributes via #attributes=' do
        @object = @klass.new
        @object.attributes = {:a => 'one'}
        @object.a.should == 'one'
      end
      
      it 'allows to read all attributes via #attributes' do
        @object = @klass.new :a => 'one'
        @object.attributes['a'].should == 'one'
      end
      
      describe 'ActiveModel::Dirty behavior' do
        it 'marks changed attributes and stores old value' do
          @object = @klass.new :a => 'one'
          @object.a = 'two'
          @object.should be_changed
          @object.a_was.should == 'one'
          @object.should be_a_changed
        end
        
        it 'marks initial values as changed' do
          @object = @klass.new :a => 'one'
          @object.should be_changed
          @object.should be_a_changed
        end
      end
    end
  end
end