class CreateVocessLocutors < ActiveRecord::Migration[5.1]
  def change
    create_table :vocess_locutors do |t|
      t.references :concurso, foreign_key: true
      t.string :nombresLocutor
      t.string :apellidosLocutor
      t.string :emailLocutor
      t.string :originalURL
      t.string :convertidaURL
      t.text :comentarios
      t.string :estado

      t.timestamps
    end
  end
end
