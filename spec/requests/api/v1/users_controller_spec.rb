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
end
