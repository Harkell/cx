class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.integer :company_number
      t.string :company_type
      t.hstore :address
      t.hstore :accounts
      t.boolean :overdue
      t.boolean :has_charges
      t.boolean :has_insolvency_history
      t.string :jurisdiction
      t.datetime :date_of_creation
      t.boolean :company_status
      t.datetime :last_made_up_to
      t.text :sic_codes, array: true, default: []
      t.boolean :can_file

      t.timestamps
    end
  end
end
