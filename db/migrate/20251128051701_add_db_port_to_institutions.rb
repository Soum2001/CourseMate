class AddDbPortToInstitutions < ActiveRecord::Migration[8.0]
  def change
    add_column :institutions, :db_port, :integer
  end
end
