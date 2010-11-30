require 'test_helper'

Kangaroo.initialize 'kangaroo.yml'

class KangarooTest < ActiveSupport::TestCase
  test "After initialization Kangaroo should have database connection" do    
    assert_not_nil Kangaroo.database    
  end
  
  test "Kangaroo should have loaded models" do
    assert !Kangaroo.database.models.empty?
    assert Oo.const_defined?('Account')    
  end
  
  test "Models should be nested" do
    assert_kind_of Module, Oo::Account
    assert_kind_of Class, Oo::Account::Move
    assert_kind_of Class, Oo::Account::Move::Line
  end  
end