class AddVozDataToVocessLocutors < ActiveRecord::Migration[5.1]
  def change
    add_column :vocess_locutors, :voz_data, :text
  end
end
