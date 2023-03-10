FactoryBot.define do
    factory :sleep do
        association :user
        clock_in { Time.current }
        clock_out { Time.current + 8.hours }
        duration { 8.hours.to_i }

        trait :with_empty_clock_out do
          clock_out { nil }
        end
    end
end