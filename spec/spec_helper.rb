require 'support/active_record'
require 'polymorphic_integer_type'
require 'support/configuration'
require 'support/link'
require 'support/animal'
require 'support/dog'
require 'support/person'
require 'support/food'
require 'support/drink'



RSpec.configure do |config|

  config.before(:suite) do
    ActiveRecord::Migrator.up "#{File.dirname(__FILE__)}/support/migrations"
  end

  # No need to return the run the down migration after the test
  # but useful while in development
  # config.after(:suite) do
  #   ActiveRecord::Migrator.down "#{File.dirname(__FILE__)}/support/migrations"
  # end


  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

end
