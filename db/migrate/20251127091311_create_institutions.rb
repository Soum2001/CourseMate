class CreateInstitutions < ActiveRecord::Migration[8.0]
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :identifier
      t.string :db_name
      t.string :db_username
      t.string :db_password
      t.string :db_host

      t.timestamps
    end
  end
end
