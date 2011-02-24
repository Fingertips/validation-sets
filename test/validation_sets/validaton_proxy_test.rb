require 'test_helper'

if ActiveRecord::Base.respond_to?(:set_callback) # Rails 3
  class Person
    def self.arguments(*args)
      args
    end
  end
  
  class ValidationProxyTest < ActiveSupport::TestCase
    test "forwards missing methods to the model" do
      validation_proxy = ValidationSets::ValidationProxy.new(Person, :admin)
      args = validation_proxy.arguments
      assert args.last.has_key?(:if)
    end
  end
end