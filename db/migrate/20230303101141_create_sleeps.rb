class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :clock_out
      t.float :duration
      t.timestamps
    end
  end
end
