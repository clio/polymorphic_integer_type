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
require 'support/namespaced_activity'
require 'byebug'
require 'pry'

RSpec.configure do |config|
  config.before(:suite) do
    database_config = YAML.load(File.open("#{File.dirname(__FILE__)}/support/database.yml"))
    ActiveRecord::Base.establish_connection(database_config)
    if Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new("6.0.0")
      ActiveRecord::MigrationContext.new("#{File.dirname(__FILE__)}/support/migrations", ActiveRecord::Base.connection.schema_migration).migrate
    elsif Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new("5.2.0")
      ActiveRecord::MigrationContext.new("#{File.dirname(__FILE__)}/support/migrations").migrate
    end
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
