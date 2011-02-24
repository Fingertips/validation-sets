require 'test_helper'

if !ActiveRecord::Base.respond_to?(:set_callback) # Rails 2
  class ValidationSetTest < ActiveSupport::TestCase
    test "forwards missing methods to the model" do
      model = 'Model'
      validation_set = ValidationSets::ValidationSet.new(model, :admin)
      assert_equal 5, validation_set.length
    end
  end
end