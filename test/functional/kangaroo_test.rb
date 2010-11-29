require 'test_helper'

Kangaroo.initialize 'kangaroo.yml'

class KangarooTest < ActiveSupport::TestCase
  test "After initialization Kangaroo should have database connection" do    
    assert_not_nil Kangaroo.default    
  end
  
  test "Kangaroo should have loaded models" do
    assert !Kangaroo.default.models.empty?
    assert Oo.const_defined?('Account')    
  end
  
  test "Models should be nested" do
    assert_kind_of Module, Oo::Account
    assert_kind_of Class, Oo::Account::Move
    assert_kind_of Class, Oo::Account::Move::Line
  end
  
  test "Models should have accessors for their fields" do
    assert_respond_to Oo::Account::Account
  end
end