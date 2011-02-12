require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Persistence do
      
      before :each do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.define_multiple_accessors :a, :b
        @klass.stub!(:default_attributes).and_return({})
      end

      context '#instantiate' do
        it 'raises error if id is missing' do
          lambda { @klass.send(:instantiate, {}) }.should raise_error(Kangaroo::Model::Persistence::InstantiatedRecordNeedsIDError)
        end

        it 'returns an instance' do
          object = @klass.send :instantiate, {:id => 1, :a => 'one'}
          object.should be_an_instance_of(@klass)
        end

        it 'sets attributes' do
          object = @klass.send :instantiate, {:id => 1, :a => 'one'}
          object.a.should == 'one'
        end
      end
      
      
      describe '#find' do
        it 'raises RecordNotFound error if no record was found' do
          @remote_stub = mock 'remote'
          @klass.stub!(:remote).and_return @remote_stub

          @remote_stub.stub!(:read).
            and_return []
          lambda {@klass.find(1)}.should raise_error(Kangaroo::RecordNotFound)
        end
      end

      it 'marks initialized record as new' do
        object = @klass.new
        object.should be_a_new_record
      end

      it 'marks instantiated record as persisted' do
        object = @klass.send :instantiate, {:id => 1}
        object.should be_persisted
      end
    end
  end
end