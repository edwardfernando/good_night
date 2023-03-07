require 'rails_helper'

RSpec.describe "Api::V1::ClockInsControllers", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "POST #create" do
    context 'last clock_in has not been clocked out' do
      before do
        FactoryBot.create(:sleep, :with_empty_clock_out, user: user)
        post api_v1_user_clock_ins_path(user_id: user.id)
      end

      it "return bad_request" do
        expect(response).to have_http_status(:bad_request)
        responseObject = Response.to_response(response.body)
        expect(responseObject.message).to match("you need to clock out first")
      end
    end

    context 'all clock_ins have been clocked out' do
      before do
        post api_v1_user_clock_ins_path(user_id: user.id)
      end

      it 'creates a new clock for the user' do
        expect(user.sleeps.count).to eq(1)
      end

      it "returns an ok message" do
        expect(response).to have_http_status(:ok)
        responseObject = Response.to_response(response.body)
        expect(responseObject.message).to match("clocked in successfully")
        expect(responseObject.data).to match(user.sleeps.order(created_at: :desc).as_json)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      FactoryBot.create_list(:sleep, 3, user: user)
      delete api_v1_user_clock_ins_path(user_id: user.id)
    end

    it 'updates the last clocks in record and set the clock_out to current time' do
      expect(user.sleeps.last.clock_out).to be_present
      expect(user.sleeps.last.duration).to be_present
    end

    it 'returns an ok message' do
      expect(response).to have_http_status(:ok)
      responseObject = Response.to_response(response.body)
      expect(responseObject.message).to match("clocked out successfully")
    end
  end

  describe "GET #index" do
    before do
      FactoryBot.create_list(:sleep, 3, user: user)
      get api_v1_user_clock_ins_path(user_id: user.id)
    end

    it "returns list of clock_ins belong to the current user" do
      expect(response).to have_http_status(:ok)
      responseObject = Response.to_response(response.body)
      expect(responseObject.message).to match("success")
      expect(responseObject.data).to match(user.sleeps.order(created_at: :desc).as_json)
    end
  end  
end
