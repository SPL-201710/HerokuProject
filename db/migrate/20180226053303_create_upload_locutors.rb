class CreateUploadLocutors < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_locutors do |t|
      t.string :nombre
      t.text :image_data

      t.timestamps
    end
  end
end
