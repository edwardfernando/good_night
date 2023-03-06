require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleeps) }
    it { should have_many(:followed_users).with_foreign_key(:follower_id).class_name('Follow') }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users).with_foreign_key(:followee_id).class_name('Follow') }
    it { should have_many(:followers).through(:following_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
