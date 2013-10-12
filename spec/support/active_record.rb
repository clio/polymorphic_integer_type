require 'active_record'
Dir["#{File.dirname(__FILE__)}/migrations/*.rb"].each {|f| require f}

config = {
  :adapter => "mysql",
  :host => "localhost",
  :database => "polymorphic_integer_type_test",
  :username => "root",
  :password => ""
}
ActiveRecord::Base.establish_connection(config)

