module ValidationSets
  class ValidationSet
    def initialize(model, label)
      @model = model
      @label = label
    end
    
    def validate(*params, &block)
      send(validation_set_method(:save, @label), *params, &block)
    end
    
    def validate_on_create(*params, &block)
      send(validation_set_method(:create, @label), *params, &block)
    end
    
    def validate_on_update(*params, &block)
      send(validation_set_method(:update, @label), *params, &block)
    end
    
    def method_missing(method, *attributes, &block)
      @model.send(method, *attributes, &block)
    end
  end
end