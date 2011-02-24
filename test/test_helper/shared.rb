module ValidationSetsTests
  module Initializer
    VENDOR_RAILS = File.expand_path('../../../../../../vendor/rails', __FILE__)
    PLUGIN_ROOT = File.expand_path('../../../', __FILE__)
    
    def self.rails_directory
      if File.exist?(VENDOR_RAILS)
        VENDOR_RAILS
      end
    end
    
    def self.configure_database
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
      ActiveRecord::Migration.verbose = false
    end
    
    def self.setup_database
      ActiveRecord::Schema.define(:version => 1) do
        create_table :accounts do |t|
          t.column :fullname, :string
          t.column :email, :string
          t.column :username, :string
          t.column :password, :string
        end
      end
    end
    
    def self.teardown_database
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.drop_table(table)
      end
    end
    
    def self.start
      load_dependencies
      configure_database
    end
  end
end