class AddForeignKey < ActiveRecord::Migration[5.1]
  def change
     add_foreign_key :voces_locutors, :concursos
     add_foreign_key :concursos, :administradors
  end
end
