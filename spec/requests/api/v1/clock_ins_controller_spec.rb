require 'rails_helper'

RSpec.describe "Api::V1::ClockInsControllers", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "POST /index" do
    before do
      post api_v1_user_clock_ins_path(user_id: user.id)
    end

    it 'creates a new clock for the user' do
      expect(user.sleeps.count).to eq(1)
    end

    it "return an ok message" do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("clocked in successfully")
    end
  end

  describe "GET /index" do
    before do
      FactoryBot.create_list(:sleep, 3, user: user)
      get api_v1_user_clock_ins_path(user_id: user.id)
    end

    it "returns list of clock_ins belong to the current user" do
      expected_result = {
        status: :ok,
        clock_ins: user.sleeps.order(created_at: :desc).as_json
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(expected_result.to_json)
    end
  end  
end
