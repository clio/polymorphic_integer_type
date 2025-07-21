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

    ActiveRecord::Base.establish_connection(database_config)

    ActiveRecord::MigrationContext.new(migrations_path).migrate
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
