# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180218042638) do

  create_table "administradors", force: :cascade do |t|
    t.string "nombres"
    t.string "apellidos"
    t.string "email"
    t.string "contrasena"
    t.string "nombreEmpresa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concursos", force: :cascade do |t|
    t.string "nombreConcurso"
    t.datetime "fechaInicio"
    t.datetime "fechaFin"
    t.integer "valorPagar"
    t.text "recomendaciones"
    t.text "guionConcurso"
    t.string "imagenBanner"
    t.string "concursoURL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voces_locutors", force: :cascade do |t|
    t.string "nombresLocutor"
    t.string "apellidosLocutor"
    t.string "emailLocutor"
    t.string "originalURL"
    t.string "convertidaURL"
    t.text "comentarios"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
