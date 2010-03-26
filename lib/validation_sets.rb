module ValidationSets
  autoload :ValidationSet, 'validation_sets/validation_set'
  
  attr_accessor :current_validation_set
  
  def validation_set_method(on, label)
    case on
      when :save   then "validate_#{label}_set".to_sym
      when :create then "validate_on_create_#{label}_set".to_sym
      when :update then "validate_on_update_#{label}_set".to_sym
    end
  end
  
  def validation_method(on)
    if current_validation_set
      validation_set_method(on, current_validation_set)
    else
      super
    end
  end
  
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
    
    def use_validation_set(set)
      @_validation_set = set
    end
  end
end

class ActiveRecord::Base
  extend ValidationSets
  include ValidationSets::InstanceMethods
end