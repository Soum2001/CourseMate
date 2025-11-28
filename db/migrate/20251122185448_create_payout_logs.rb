class CreatePayoutLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :payout_logs do |t|
      t.integer :instructor_id
      t.integer :course_id
      t.decimal :amount
      t.string :stripe_transfer_id

      t.timestamps
    end
  end
end
