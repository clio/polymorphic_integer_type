# PolymorphicIntegerType

Rails' polymorphic associations are pretty useful. The example they give to set it up looks like:
```ruby
class Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end
 
class Employee < ActiveRecord::Base
  has_many :pictures, as: :imageable
end
 
class Product < ActiveRecord::Base
  has_many :pictures, as: :imageable
end
```

With a migration that looks like:
```ruby
class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string  :name
      t.integer :imageable_id
      t.string  :imageable_type
      t.timestamps
    end
  end
end
```

The problem with this approach is that `imageable_type` is a string (and by default it is 255 characters). This is a little ridiculous. For comparison, if we had a state machine with X states, would we describe the states with strings `"State1", "State2", etc` or would we just enumerate the state column and make it an integer? This gem will allow us to use an integer for the `imageable_type` column. 

## Installation

Add this line to your application's Gemfile:

    gem 'polymorphic_integer_type'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polymorphic_integer_type

## Usage

The gem is pretty straightforward to use.

First, include the extensions module and add the `integer_type`  option to the associations that are going to be using this. (That way it will play nicely with polymorphic associations whose type you would rather leave as a string.)
```ruby
class Picture < ActiveRecord::Base
  include PolymorphicIntegerType::Extensions
  belongs_to :imageable, polymorphic: true, integer_type: true
end
 
class Employee < ActiveRecord::Base
  include PolymorphicIntegerType::Extensions
  has_many :pictures, as: :imageable, integer_type: true
end
 
class Product < ActiveRecord::Base
  include PolymorphicIntegerType::Extensions
  has_many :pictures, as: :imageable, integer_type: true
end
```

Second, you need to create a mapping for the polymorphic associations. This should be loaded before the models. Putting it in an initializer is good (`config/initializers/polymorphic_type_mapping.rb`)
```ruby
PolymorphicIntegerType::Mapping.configuration do |config|

  config.add :imageable, {1 => "Employee", 2 => "Product" }  	

end 
```

Note: The mapping here can start from whatever integer you wish, but I would advise not using 0. The reason being that if you had a new class, for instance `Avatar`, and also wanted to use this polymorphic association but forgot to include it in the mapping, it would effectively get `to_i` called on it and stored in the database. `"Avatar".to_i == 0`, so if your mapping included 0, this would create a weird bug. 

If you want to convert a polymorphic association that is already a string, you'll need to set up a migration. (Assuming SQL for the time being, but this should be pretty straightforward.)
```ruby
class PictureToPolymorphicIntegerType < ActiveRecord::Migration
  
  def up
    change_table :pictures do |t|
      t.integer :new_imageable_type
    end

    execute <<-SQL
      UPDATE reminders
      SET new_imageable_type = CASE imageable_type
                                 WHEN 'Employee' THEN 1
                                 WHEN 'Product' THEN 2
                               END
    SQL

    change_table :pictures, :bulk => true do |t|
      t.remove :imageable_type
      t.rename :new_imageable_type, :imageable_type
    end
  end

  def down
    change_table :pictures do |t|
      t.string :new_imageable_type
    end

    execute <<-SQL
      UPDATE picture
      SET new_imageable_type = CASE imageable_type
                                 WHEN 1 THEN 'Employee'
                                 WHEN 2 THEN 'Product'
                               END
    SQL

    change_table :pictures, :bulk => true do |t|
      t.remove :imageable_type
      t.rename :new_imageable_type, :imageable_type
    end
  end
end
```

Lastly, you will need to be careful of any place where you are doing raw SQL queries with the string (`imageable_type = 'Employee'`). They should use the integer instead.
  


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
