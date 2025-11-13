class AddVideoUrlToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :video_url, :string
  end
end
