class SleepSerializer < ActiveModel::Serializer
  attributes :id, :clock_in, :clock_out, :duration
  belongs_to :user
end
