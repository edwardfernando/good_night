# This model represents a sleep record for a user. It belongs to a user and contains the clock in and clock out times,
# as well as the duration of the sleep in seconds. Clock in time is required for all sleep records, while clock out
# and duration are optional and calculated when the user clocks out.
#
# Associations:
# - belongs_to :user
#
# Validations:
# - validates :clock_in, presence: true
# - validates :user_id, presence: true
class Sleep < ApplicationRecord
  belongs_to :user
end
