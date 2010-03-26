require File.expand_path('../test_helper', __FILE__)

class Account < ActiveRecord::Base
  attr_accessor :current_password
  
  private
  
  def password_should_match_management_requirements
    if password.blank?
      errors.add(:password, "can't be blank")
    elsif password !~ /\d/
      errors.add(:password, "should contain at least one number")
    end
  end
  
  def password_should_match_current
    if send(:attribute_was, 'password') != current_password
      errors.add(:current_password, "is wrong")
    end
  end
  
  validates_presence_of :fullname
  
  # Admins create accounts with a blank username and password
  validation_set_for(:admin) do |set|
    set.validates_presence_of :email, :on => :create
  end
  
  # Members are force to choose a username and password during activation
  validation_set_for(:activation) do |set|
    set.validates_presence_of :email
    set.validates_presence_of :username
    set.validate :password_should_match_management_requirements
  end
  
  # Members need to set the current password when updating their account after activation
  validation_set_for(:member) do |set|
    set.validates_presence_of :email
    set.validates_presence_of :username
    set.validate :password_should_match_management_requirements
    set.validate :password_should_match_current
  end
end

class ValidationSetsTest < ActiveSupport::TestCase
  
  test "global validation should always run" do
    account = Account.new
    assert !account.valid?
    assert account.errors.on(:fullname)
    
    account.fullname = "Patricia Herder"
    assert account.valid?
    assert account.errors.empty?
  end
  
  test "a validation set runs when it's active" do
    account = Account.new
    account.use_validation_set(:activation)
    assert !account.valid?
    assert account.errors.on(:email)
    assert account.errors.on(:username)
    assert account.errors.on(:password)
    
    account.fullname = "Patricia Herder"
    account.email = 'patricia@example.com'
    account.username = 'patricia'
    account.password = 'secret1'
    assert account.valid?
    assert account.errors.empty?
  end
  
  test "a validation in a validation set runs a the correct time" do
    account = Account.new
    account.use_validation_set(:admin)
    assert !account.valid?
    assert account.errors.on(:fullname)
    assert account.errors.on(:email)
    
    account.fullname = "Patricia Herder"
    account.email = 'patricia@example.com'
    assert account.valid?
    assert account.errors.empty?
    
    assert account.save
    
    account.email = nil
    assert account.save
  end
  
  def setup
    ValidationSetsTests::Initializer.setup_database
  end
  
  def teardown
    ValidationSetsTests::Initializer.teardown_database
  end
end