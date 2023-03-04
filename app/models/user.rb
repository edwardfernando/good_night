class User < ApplicationRecord
    has_many :sleeps

    validates :name, presence: true
end
