class Event < ActiveRecord::Base
  # The event class is a skateboard supposed to be come a service.
  belongs_to :user, foreign_key: :user_uuid
  serialize :payload, JSON
end
