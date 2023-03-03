class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in, null: false
      t.datetime :clock_out
      t.integer :duration
      t.timestamps
    end

    add_index :sleeps, :user_id
  end
end
