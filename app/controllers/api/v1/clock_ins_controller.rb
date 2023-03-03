class Api::V1::ClockInsController < ApplicationController
    def create
        # do not allow if the last clock in hasnt been clocked-out
        clock_in = current_user.sleeps.create!
        render json: { status: :ok, message: "clocked in successfully"}
    end

    def destroy
        last_record = current_user.sleeps.last
        now = Time.now
        last_record.update!(clock_out: now, duration: (now - last_record.clock_in))
        render json: { status: :ok, message: "clocked out successfully" }
    end

    def index
        clock_ins = current_user.sleeps.order(created_at: :desc)
        render json: { status: :ok, clock_ins: clock_ins}
    end

    private

    def current_user
        @current_user ||= User.find_by(id: params[:user_id] || params[:id])
    end
end
