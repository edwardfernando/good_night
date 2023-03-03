class Api::V1::ClockInsController < ApplicationController
    def create
        clock_in = current_user.sleeps.create!
        render json: { status: :ok, message: "clocked in successfully"}
    end

    def index
        clock_ins = current_user.sleeps.order(created_at: :desc)
        render json: { status: :ok, clock_ins: clock_ins}
    end

    private

    def current_user
        @current_user ||= User.find_by(id: params[:user_id])
    end
end
