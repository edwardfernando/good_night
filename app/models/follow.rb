# The Follow model represents a relationship between two users where one user is following another.
#
# Attributes:
#   - follower_id: the ID of the user who is following another user
#   - followee_id: the ID of the user who is being followed by another user
#
# Associations:
#   - belongs_to :follower, class_name: 'User': the user who is following another user
#   - belongs_to :followee, class_name: 'User': the user who is being followed by another user
#
# Validations:
#   - validates :follower_id, uniqueness: { scope: :followee_id }: ensures that a user can only follow another user once
#   - validates :followee_id, uniqueness: { scope: :follower_id }: ensures that a user can only be followed by another user once
class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followee_id }
  validates :followee_id, uniqueness: { scope: :follower_id }
end
