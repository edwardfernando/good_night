require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { FactoryBot.create(:user) }
  let(:followee) { FactoryBot.create(:user) }

  describe 'validations' do
    context 'when the follower is already following the followee' do
      before { Follow.create(follower: follower, followee: followee) }

      it 'is not valid' do
        follow = Follow.new(follower: follower, followee: followee)
        expect(follow).not_to be_valid
        expect(follow.errors.full_messages).to include('Follower has already been taken')
      end
    end

    context 'when the followee is already being followed by the follower' do
      before { Follow.create(follower: followee, followee: follower) }

      it 'is not valid' do
        follow = Follow.new(follower: followee, followee: follower)
        expect(follow).not_to be_valid
        expect(follow.errors.full_messages).to include('Followee has already been taken')
      end
    end

    context 'when the follower and followee are different' do
      it 'is valid' do
        follow = Follow.new(follower: follower, followee: followee)
        expect(follow).to be_valid
      end
    end
  end
end
