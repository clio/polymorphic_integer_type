require 'yaml'
require 'active_record'
require 'polymorphic_integer_type'
require 'support/configuration'
require 'support/link'
require 'support/animal'
require 'support/namespaced_animal'
require 'support/namespaced_plant'
require 'support/dog'
require 'support/person'
require 'support/food'
require 'support/drink'
require 'support/profile'
require 'support/profile_history'
require 'support/namespaced_activity'
require 'byebug'
require 'pry'

RSpec.configure do |config|
  config.before(:suite) do
    database_config = YAML.load(File.open("#{File.dirname(__FILE__)}/support/database.yml"))
    migrations_path = "#{File.dirname(__FILE__)}/support/migrations"
    active_record_version = Gem::Version.new(ActiveRecord::VERSION::STRING)

    ActiveRecord::Base.establish_connection(database_config)
    
    if active_record_version >= Gem::Version.new("6.1") && active_record_version < Gem::Version.new("7.0")
      ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::SchemaMigration).migrate      
    end

    if active_record_version >= Gem::Version.new("7.0")
      ActiveRecord::MigrationContext.new(migrations_path).migrate
    end
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
