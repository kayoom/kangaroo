require 'spec_helper'

module Kangaroo
  describe Relation do
    before do
      @target = mock 'target'
      @relation = Relation.new @target
    end
    
    it 'delegates basic methods to its target' do
      %w(all first find count size length).each do |basic_method|
        @target.should_receive basic_method
        @relation.send basic_method
      end
    end
    
    it 'delegates array methods via target#all' do
      array_mock = mock 'array'
      array_mock.should_receive 'each'
      
      @target.should_receive('all').and_return array_mock
      @relation.send :each
    end
    
    it 'stores conditions via where() and hands them over to target#all' do
      @target.should_receive(:all).with hash_including(:conditions => [{:a => :b}])
      @relation.where(:a => :b).all
    end
    
    it 'merges chained where() conditions' do
      @target.should_receive(:all).with hash_including(:conditions => [{:a => :b}, {:b => :c}])
      @relation.where(:a => :b).where(:b => :c).all
    end
    
    it 'doesnt change the relation on chaining' do
      @target.should_receive(:all).with hash_including(:conditions => [{:a => :b}])
      chained_relation = @relation.where(:a => :b)
      chained_relation.where(:b => :c)
      chained_relation.all
    end
    
    it 'stores limit and hands it over to target#all' do
      @target.should_receive(:all).with hash_including(:limit => 10)
      @relation.limit(10).all
    end
    
    it 'overwrites limit clauses when chained' do
      @target.should_receive(:all).with hash_including(:limit => 10)
      @relation.limit(20).limit(10).all
    end
    
    it 'stores offset and hands it over to target#all' do
      @target.should_receive(:all).with hash_including(:offset => 10)
      @relation.offset(10).all
    end
    
    it 'overwrites offset clauses when chained' do
      @target.should_receive(:all).with hash_including(:offset => 10)
      @relation.offset(20).offset(10).all
    end
    
    it 'stores select and hands it over to target#all' do
      @target.should_receive(:all).with hash_including(:select => ["a", "b"])
      @relation.select(:a, :b).all
    end
  end
end