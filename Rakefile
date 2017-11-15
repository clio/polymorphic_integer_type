require "bundler/gem_tasks"
require "yaml"
require "active_record"

namespace :db do
  database_config = YAML.load(File.open("./spec/support/database.yml"))
  admin_database_config = database_config.merge(database: "mysql")
  migration_path = File.expand_path("./spec/support/migrations")

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(admin_database_config)
    ActiveRecord::Base.connection.create_database(database_config.fetch(:database))
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(database_config)
    ActiveRecord::Migrator.migrate(migration_path)
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(admin_database_config)
    ActiveRecord::Base.connection.drop_database(database_config.fetch(:database))
    puts "Database deleted."
  end

  desc "Reset the database"
  task reset: [:drop, :create, :migrate]
    desc 'Create a db/schema.rb file that is portable against any DB supported by AR'

  task :schema do
    # Noop to make ActiveRecord happy
  end
end
