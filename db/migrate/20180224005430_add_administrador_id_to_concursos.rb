class AddAdministradorIdToConcursos < ActiveRecord::Migration[5.1]
  def change
    add_reference :concursos, :administrator, foreign_key: true
  end
end
