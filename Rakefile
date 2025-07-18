require 'bundler/gem_tasks'
require 'yaml'
require 'active_record'

namespace :test do
  task :all do
    Dir.glob('./gemfiles/Gemfile*').each do |gemfile|
      next if gemfile.end_with?('.lock')

      puts "Running specs for #{Pathname.new(gemfile).basename}"
      system("BUNDLE_GEMFILE=#{gemfile} bundle install > /dev/null && BUNDLE_GEMFILE=#{gemfile} bundle exec rspec")
      puts ''
    end
  end
end

namespace :db do
  database_config = YAML.load(File.open('./spec/support/database.yml'))
  migration_path = File.expand_path('./spec/support/migrations')

  desc 'Create the database'
  task :create do
    if database_config[:adapter] == 'sqlite3'
      # For SQLite3, just ensure the directory exists
      db_file = database_config.fetch(:database)
      FileUtils.mkdir_p(File.dirname(db_file)) unless File.dirname(db_file) == '.'
      puts 'Database created (SQLite3 will create file on first connection).'
    else
      # For other databases (MySQL, PostgreSQL, etc.)
      admin_config = database_config.merge(database: "mysql")
      ActiveRecord::Base.establish_connection(admin_config)
      ActiveRecord::Base.connection.create_database(database_config.fetch(:database))
      puts 'Database created.'
    end
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(database_config)

    # Handle different Rails versions
    active_record_version = Gem::Version.new(ActiveRecord::VERSION::STRING)

    if active_record_version >= Gem::Version.new("6.0")
      ActiveRecord::MigrationContext.new(migration_path).migrate
    else
      ActiveRecord::Migrator.migrate(migration_path)
    end

    Rake::Task['db:schema'].invoke
    puts 'Database migrated.'
  end

  desc 'Drop the database'
  task :drop do
    if database_config[:adapter] == 'sqlite3'
      # For SQLite3, just delete the file
      db_file = database_config.fetch(:database)
      File.delete(db_file) if File.exist?(db_file)
    else
      # For other databases (MySQL, PostgreSQL, etc.)
      admin_config = database_config.merge(database: "mysql")
      ActiveRecord::Base.establish_connection(admin_config)
      ActiveRecord::Base.connection.drop_database(database_config.fetch(:database))
    end
    puts 'Database deleted.'
  end

  desc 'Reset the database'
  task reset: [:drop, :create, :migrate]
  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'

  task :schema do
    # Noop to make ActiveRecord happy
  end
end
