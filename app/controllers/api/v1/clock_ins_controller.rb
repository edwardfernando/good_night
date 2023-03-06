class Api::V1::ClockInsController < ApplicationController
    def create
        last_record = current_user.sleeps.last
        if last_record.present?
            return render json: { status: :bad_request, message: "you need to clock out first" }, status: :bad_request if last_record.clock_out.nil?
        end

        current_user.sleeps.create!
        render json: { status: :ok, message: "clocked in successfully", clock_ins: current_user.sleeps.order(created_at: :desc)}
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


end
