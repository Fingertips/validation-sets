module ValidationSets
  # A ValidationSet instance is used to redirect the original validation methods (validate,
  # validate_on_create, and validate_on_update) to the callback chain for the set.
  class ValidationSet
    def initialize(model, label)
      @model = model
      @label = label
    end
    
    # Adds a validation method or proc that always runs
    def validate(*params, &block)
      send(validation_set_method(:save, @label), *params, &block)
    end
    
    # Adds a validation method or proc that runs on create
    def validate_on_create(*params, &block)
      send(validation_set_method(:create, @label), *params, &block)
    end
    
    # Adds a validation method or proc that runs on update
    def validate_on_update(*params, &block)
      send(validation_set_method(:update, @label), *params, &block)
    end
    
    # Forwards all other methods (ie. validates_presence_of) to the model class.
    def method_missing(method, *attributes, &block)
      @model.send(method, *attributes, &block)
    end
  end
end