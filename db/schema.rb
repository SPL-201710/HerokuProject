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

ActiveRecord::Schema.define(version: 20180308081708) do

  create_table "administrators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "nombres"
    t.string "apellidos"
    t.string "nombreEmpresa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
  end

  create_table "concursos", force: :cascade do |t|
    t.string "nombreConcurso"
    t.datetime "fechaInicio"
    t.datetime "fechaFin"
    t.integer "valorPagar"
    t.text "recomendaciones"
    t.text "guionConcurso"
    t.string "imageBanner"
    t.string "concursoURL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "administrator_id"
    t.text "image_data"
    t.index ["administrator_id"], name: "index_concursos_on_administrator_id"
  end

  create_table "upload_locutors", force: :cascade do |t|
    t.string "nombre"
    t.text "image_data"
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
    t.integer "concurso_id"
    t.index ["concurso_id"], name: "index_voces_locutors_on_concurso_id"
  end

  create_table "vocess_locutors", force: :cascade do |t|
    t.integer "concurso_id"
    t.string "nombresLocutor"
    t.string "apellidosLocutor"
    t.string "emailLocutor"
    t.string "originalURL"
    t.string "convertidaURL"
    t.text "comentarios"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "voz_data"
    t.index ["concurso_id"], name: "index_vocess_locutors_on_concurso_id"
  end

end
