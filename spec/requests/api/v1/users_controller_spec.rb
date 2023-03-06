require 'rails_helper'

RSpec.describe "Api::V1::UsersController", type: :request do
  describe 'POST #create' do
    context 'name present' do
      it 'creates a new user' do
        user_params = {
          user: {
            name: "John"
          }
        }
        post api_v1_users_path, params: user_params
        expect(response).to have_http_status(:created)
        expect(response.body).to include('John')
      end
    end

    context 'name non existence' do
      it 'returns an error when name is missing' do
        user_params = {
          user: {
            name: ""
          }
        }
        post api_v1_users_path, params: user_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can't be blank")
      end
    end
  end

  describe 'POST #follow' do
    context 'following ID presents' do
      it 'add new record of followees' do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)

        post api_v1_user_follow_user_path(user_id: user_1.id, id: user_2.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("successfully following #{user_2.name}")
        expect(user_1.followees.pluck(:id)).to include(user_2.id)
        expect(user_2.followers.pluck(:id)).to include(user_1.id)
      end
    end

    context 'following ID non existence' do
      it 'returns record not found' do
        user_1 = FactoryBot.create(:user)

        post api_v1_user_follow_user_path(user_id: user_1.id, id: 9999)
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("Couldn't find User with 'id'=9999")
      end
    end
  end

  describe 'POST #unfollow' do
    context 'both followee and following are exist' do
      it 'deletes the association' do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)

        # user_1 follows user_2
        user_1.followees << user_2

        post api_v1_user_unfollow_user_path(user_id: user_1.id, id: user_2.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("successfully unfollowing #{user_2.name}")

        expect(user_1.followees.pluck(:id)).not_to include(user_2.id)
      end
    end
  end

  describe 'GET #sleep_records' do
    context 'not following' do
      it 'returns sleep_records' do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)

        # user_1 follows user_2
        user_1.followees << user_2

        get api_v1_user_sleep_records_path(user_id: user_1.id, id: user_2.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("sleep_records")
      end
    end

    context 'following' do
      it 'returns bad request' do
        user_1 = FactoryBot.create(:user)
        user_2 = FactoryBot.create(:user)

        get api_v1_user_sleep_records_path(user_id: user_1.id, id: user_2.id)
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("you need to follow #{user_2.name} to see the sleep records")
      end
    end
  end
end
