class AddConcursoIdToVocesLocutors < ActiveRecord::Migration[5.1]
  def change
    add_reference :voces_locutors, :concurso, foreign_key: true
  end
end
