require 'spec_helper'

module Kangaroo
  module Model
    describe Relation do
      before do
        @target = mock 'target'
        @relation = Relation.new @target
      end

      it 'delegates array methods via target#all' do
        array_mock = mock 'array'
        array_mock.should_receive :each

        @target.should_receive(:search_and_read).and_return array_mock
        @relation.send :each
      end

      it 'stores conditions via where() and hands them over to target#all' do
        @target.should_receive(:search_and_read).with [{:a => :b}], anything, anything
        @relation.where(:a => :b).all
      end

      it 'merges chained where() conditions' do
        @target.should_receive(:search_and_read).with [{:a => :b}, {:b => :c}], anything, anything
        @relation.where(:a => :b).where(:b => :c).all
      end

      it 'doesnt change the relation on chaining' do
        @target.should_receive(:search_and_read).with [{:a => :b}], anything, anything
        chained_relation = @relation.where(:a => :b)
        chained_relation.where(:b => :c)
        chained_relation.all
      end

      it 'stores limit and hands it over to target#all' do
        @target.should_receive(:search_and_read).with [], hash_including(:limit => 10), anything
        @relation.limit(10).all
      end

      it 'overwrites limit clauses when chained' do
        @target.should_receive(:search_and_read).with [], hash_including(:limit => 10), anything
        @relation.limit(20).limit(10).all
      end

      it 'stores offset and hands it over to target#all' do
        @target.should_receive(:search_and_read).with [], hash_including(:offset => 10), anything
        @relation.offset(10).all
      end

      it 'overwrites offset clauses when chained' do
        @target.should_receive(:search_and_read).with [], hash_including(:offset => 10), anything
        @relation.offset(20).offset(10).all
      end

      it 'stores select and hands it over to target#all' do
        @target.should_receive(:search_and_read).
          with [], anything, hash_including(:fields => ["a", "b"])
        @relation.select(:a, :b).all
      end

      it 'stores context hands it over to target#all' do
        @target.should_receive(:search_and_read).
          with [], hash_including(:context => {:lang => 'de_DE'}), hash_including(:context => {:lang => 'de_DE'})
        @relation.context(:lang => 'de_DE').all
      end

      it 'merges chained contexts' do
        @target.should_receive(:search_and_read).
          with [], hash_including(:context => {:lang => 'de_DE', :tz => 'de'}), hash_including(:context => {:lang => 'de_DE', :tz => 'de'})
        @relation.context(:lang => 'de_DE').context(:tz => 'de').all
      end
      
      describe '#reverse' do
        it 'adds descending id order if no order was specified' do
          @relation.reverse.order_clause.should == ['id desc']
        end
        
        it 'reverses previously specified orders' do
          @relation.order('name').reverse.order_clause.should == ['name desc']
          @relation.order('name', true).reverse.order_clause.should == ['name']          
          @relation.order('name').order('code', true).reverse.order_clause.should == ['name desc', 'code']
        end
      end

      describe '#[]' do
        it 'doesnt touch existing limit clause' do
          @target.should_receive(:search_and_read).
            with([], hash_including(:limit => 2), anything).
            and_return []
          @relation.limit(2)[1]
        end

        it 'doesnt touch existing offset clause' do
          @target.should_receive(:search_and_read).
            with([], hash_including(:offset => 40), anything).
            and_return []
          @relation.offset(40)[10]
        end

        it '[n] returns the n-th record' do
          @target.should_receive(:search_and_read).
            with([], hash_including(:limit => 1, :offset => 21), anything).
            and_return []
          @relation[21]
        end

        it '[n, m] return m records skipping n' do
          @target.should_receive(:search_and_read).
            with [], hash_including(:limit => 4, :offset => 21), anything
          @relation[21, 4]
        end

        it '[n..m] returns records n to m' do
          @target.should_receive(:search_and_read).
            with [], hash_including(:limit => 5, :offset => 21), anything
          @relation[21..25]
        end
      end
    end
  end
end