class AddForeign < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :voces_locutors, :concursos, index: true, foreign_key: true
    add_foreign_key :concursos, :administradors, index: true, foreign_key: true
  end
end
