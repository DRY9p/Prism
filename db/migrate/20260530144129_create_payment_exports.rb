class CreatePaymentExports < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_exports do |t|
      t.integer :service_item_id
      t.integer :medical_record_id
      t.integer :appointment_id
      t.integer :prescription_id
      t.integer :treatment_action_id
      t.integer :appointment_external_id
      t.datetime :date_complete
      t.decimal :appointment_item_cost
      t.integer :payment_method_id
      t.boolean :is_paid
      t.decimal :prescription_original_price_per_one
      t.decimal :prescription_price_per_one
      t.decimal :treatment_action_original_price_per_one
      t.decimal :treatment_action_price_per_one
      t.integer :bill_id
      t.integer :bill_item_id
      t.integer :bill_status
      t.datetime :bill_paid_date
      t.string :bill_item_name
      t.decimal :bill_item_original_price_per_one
      t.decimal :bill_item_price_per_one
      t.integer :quantity
      t.integer :payment_instrument_id
      t.integer :medical_record_treatment_program_id
      t.integer :user_id_initiator
      t.integer :schedule_item_id
      t.integer :user_id_complete
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.decimal :bill_item_original_price_per_one_mrtp
      t.decimal :bill_item_price_per_one_mrtp
      t.datetime :date_complete_mrtp

      t.timestamps
    end
  end
end
