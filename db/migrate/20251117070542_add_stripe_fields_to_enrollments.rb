class AddStripeFieldsToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollments, :stripe_customer_id, :string
    add_column :enrollments, :stripe_charge_id, :string
  end
end
