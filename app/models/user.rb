# Model for users of the application. A user has many sleep records and can follow and be followed by other users.

# Associations:
# - sleeps: the sleep records belonging to this user
# - followed_users: the users that this user is following
# - followees: the users that this user is following (through the followed_users association)
# - following_users: the users that are following this user
# - followers: the users that are following this user (through the following_users association)
#
# Validations:
# - name: must be present
class User < ApplicationRecord
    has_many :sleeps

    has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
    has_many :followees, through: :followed_users
    has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
    has_many :followers, through: :following_users

    validates :name, presence: true
end
