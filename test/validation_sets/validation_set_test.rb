require File.expand_path('../../test_helper', __FILE__)

class ValidationSetTest < ActiveSupport::TestCase
  test "forwards missing methods to the model" do
    model = 'Model'
    validation_set = ValidationSets::ValidationSet.new(model, :admin)
    assert_equal 5, validation_set.length
  end
end