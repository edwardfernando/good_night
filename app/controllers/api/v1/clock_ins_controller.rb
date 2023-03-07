class Api::V1::ClockInsController < ApplicationController

    # Creates a new sleep record with a clock in time for the current user.
    #
    # If the current user has a sleep record with a clock out time that is not nil,
    # indicating that the user has not clocked out of their previous sleep period,
    # this function will return a JSON response with a status of :bad_request and an error message
    # indicating that the user needs to clock out first.
    #
    # Returns:
    #   - A JSON response with a status of :ok and a message indicating that the user has successfully clocked in,
    #     along with a list of the user's most recent sleep records sorted by creation date.
    def create
        last_record = current_user.sleeps.last
        if last_record.present?
            return render json: Response.new(status: :bad_request, message: "you need to clock out first"), status: :bad_request if last_record.clock_out.nil?
        end

        current_user.sleeps.create!
        render json: Response.new(status: :ok, message: "clocked in successfully", data: current_user.sleeps.order(created_at: :desc))
    end

    # Updates the clock out time and duration of the current user's most recent sleep record to the current time,
    # indicating that the user has finished sleeping.
    #
    # Returns:
    #   - A JSON response with a status of :ok and a message indicating that the user has successfully clocked out.
    def destroy
        last_record = current_user.sleeps.last
        now = Time.now
        last_record.update!(clock_out: now, duration: (now - last_record.clock_in))
        render json: Response.new(status: :ok, message: "clocked out successfully")
    end

    # Returns a JSON response containing a list of the current user's sleep records, ordered by the time they were created.
    #
    # Returns:
    #   - A JSON response with a status of :ok and a list of the current user's sleep records, ordered by the time they were created.
    def index
        clock_ins = current_user.sleeps.order(created_at: :desc)
        render json: Response.new(status: :ok, message: "success", data: clock_ins)
    end


end
