module ValidationSets
  autoload :ValidationSet, 'validation_sets/validation_set'
  
  # Used to set the current validation set during definition of the model
  attr_accessor :current_validation_set
  
  # Returns the name of the validation callback method for a save method and the label of a
  # validation set.
  def validation_set_method(on, label)
    case on
      when :save   then "validate_#{label}_set".to_sym
      when :create then "validate_on_create_#{label}_set".to_sym
      when :update then "validate_on_update_#{label}_set".to_sym
    end
  end
  
  # Returns the name of the validation callback method for a save method.
  def validation_method(on)
    if current_validation_set
      validation_set_method(on, current_validation_set)
    else
      super
    end
  end
  
  # Returns true if the validation set is defined on this class
  def validation_set_defined?(set)
    [:save, :create, :update].any? do |on|
      respond_to?(validation_set_method(on, set))
    end
  end
  
  # Add a validation set to the model.
  #
  #   class Account < ActiveRecord::Base
  #     validation_set_for(:activation) do |set|
  #       set.validates_presence_of :username
  #     end
  #   end
  def validation_set_for(label, &block)
    [:save, :create, :update].each do |save_method|
      callback_chain = validation_method(save_method)
      callback_chain_for_set = validation_set_method(save_method, label)
      unless respond_to?(callback_chain_for_set)
        define_callbacks(callback_chain_for_set)
        define_method(callback_chain_for_set) { run_callbacks(callback_chain_for_set) }
        send(callback_chain, callback_chain_for_set, :if => Proc.new { |r| label.to_sym == r._validation_set })
      end
    end
    
    validation_set = ValidationSet.new(self, label)
    
    before = current_validation_set
    self.current_validation_set = label.to_sym
    block.call(validation_set)
    self.current_validation_set = before
  end
  
  module InstanceMethods
    attr_reader :_validation_set
    
    # Set the active validation set on the model. After calling this both the global as well as
    # the validations defined in the set will run.
    #
    # Raises an exception when asked to use an unknown validation set.
    #
    # Example:
    #
    #   account = Account.new
    #   account.use_validation_set(:admin) # Turns on the :admin validation set
    #   account.use_validation_set(nil)    # Turns off all validation sets
    def use_validation_set(set)
      if self.class.validation_set_defined?(set)
        @_validation_set = set
      else
        raise ArgumentError, "There is no validation set `#{set}'"
      end
    end
  end
end

module ActiveRecord #:nodoc:
  class Base #:nodoc:
    extend ValidationSets
    include ValidationSets::InstanceMethods
  end
end