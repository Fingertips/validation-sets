module ValidationSets
  # A ValidationSet instance is used to add extra options to validations to make
  # sure the only run when a certain validation set is active.
  class ValidationProxy
    def initialize(model, set)
      @model = model
      @set = set
    end
    
    # Forwards all other methods (ie. validates_presence_of) to the model class
    # with extra options
    def method_missing(method, *args, &block)
      options = args.extract_options!
      options[:if] = Array.wrap(options[:if])
      options[:if] << "_validation_set == :#{@set}"
      # BUG: Callbacks get deleted from their chain when they're the same as a previous callback
      if (method == :validate) and !block and args[0].kind_of?(Symbol)
        callback = args.shift
        block = lambda { send(callback) }
      end
      args << options
      @model.send(method, *args, &block)
    end
  end
end
  