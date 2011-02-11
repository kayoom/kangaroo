require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Finder do
      include SpecHelper
      
      before :each do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.define_multiple_accessors :a, :b
        @klass.stub!(:default_attributes).and_return({})
        @remote_stub = mock 'remote'
        @klass.stub!(:remote).and_return @remote_stub
      end
      
      describe '#all' do
        it 'searches for all records, and reads all attributes' do
          @remote_stub.should_receive(:search).with([], *anythings(5)).
            and_return [1, 2]
          @remote_stub.should_receive(:read).with([1, 2], ['a', 'b'], anything).
            and_return [{:id => 1, :a => 'one'}, {:id => 2, :a => 'two'}]
          @klass.all
        end
        
      end
      
      describe '#first' do
        it 'searches for 1 record, and reads all attributes' do
          @remote_stub.should_receive(:search).with([], 0, 1, *anythings(3)).
            and_return [1]
          @remote_stub.should_receive(:read).with([1], ['a', 'b'], anything).
            and_return [{:id => 1, :a => 'one'}]
          @klass.first
        end
      end
      
      describe '#count' do
        it 'only counts how many records are present' do
          @remote_stub.should_receive(:search).with([], 0, anything, anything, anything, true).
            and_return 2
          @klass.count
        end
      end
    end
  end
end