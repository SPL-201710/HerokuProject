class CreateConcursos < ActiveRecord::Migration[5.1]
  def change
    create_table :concursos do |t|
      t.string :nombreConcurso
      t.datetime :fechaInicio
      t.datetime :fechaFin
      t.integer :valorPagar
      t.text :recomendaciones
      t.text :guionConcurso
      t.string :imageBanner
      t.string :concursoURL

      t.timestamps
    end
  end
end
