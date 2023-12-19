class Profile < ActiveRecord::Base
  belongs_to :person
  belongs_to :profile_history
end
