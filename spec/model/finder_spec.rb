require 'spec_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe Finder do
      include SpecHelper

      before :each do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.stub!(:fields_hash).and_return({})
        @klass.define_multiple_accessors :a, :b
        @klass.stub!(:default_attributes).and_return({})
        @remote_stub = mock 'remote'
        @klass.stub!(:remote).and_return @remote_stub
      end

      describe 'relational #all' do
        it 'allows specifying conditions via #where' do
          @remote_stub.should_receive(:search).with([["a", "=", "one"]], *anythings(5)).
            and_return [1]
          @remote_stub.stub!(:read).and_return [{:a => 'one', :id => 1}]
          @klass.where(:a => 'one').all
        end

        it 'allows specifying a limit via #limit' do
          @remote_stub.should_receive(:search).with([], nil, 10, *anythings(3)).
            and_return [1]
          @remote_stub.stub!(:read).and_return [{:a => 'one', :id => 1}]
          @klass.limit(10).all
        end

        it 'allows specifying an offset via #offset' do
          @remote_stub.should_receive(:search).with([], 10, nil, *anythings(3)).
            and_return [1]
          @remote_stub.stub!(:read).and_return [{:a => 'one', :id => 1}]
          @klass.offset(10).all
        end

        it 'allows specifying a sort order via #order' do
          @remote_stub.should_receive(:search).with([], nil, nil, 'a', *anythings(2)).
            and_return [1]
          @remote_stub.stub!(:read).and_return [{:a => 'one', :id => 1}]
          @klass.order('a').all
        end

        it 'allows specifying descending sort order via #order(column, true)' do
          @remote_stub.should_receive(:search).with([], nil, nil, 'a desc', *anythings(2)).
            and_return [1]
          @remote_stub.stub!(:read).and_return [{:a => 'one', :id => 1}]
          @klass.order('a', true).all
        end

        it 'allows specifying fields to read via #select' do
          @remote_stub.stub!(:search).and_return [1]
          @remote_stub.should_receive(:read).with([1], ['a'], {}).
            and_return [{:a => 'one', :id => 1}]
          @klass.select('a').all
        end

        it 'allows specifying the context via #context' do
          @remote_stub.stub!(:search).and_return [1]
          @remote_stub.should_receive(:read).
            with([1], ['a', 'b'], :lang => 'de_DE').
            and_return [{:a => 'one', :id => 1}]
          @klass.context(:lang => 'de_DE').all
        end
      end

      it 'relational #count returns number of records fulfilling the conditions' do
        @remote_stub.should_receive(:search).with([['a', '=', 'one']],  *anythings(5)).
          and_return 5
        @klass.where(:a => 'one').count.should == 5
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
          @remote_stub.should_receive(:search).with([], nil, 1, *anythings(3)).
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