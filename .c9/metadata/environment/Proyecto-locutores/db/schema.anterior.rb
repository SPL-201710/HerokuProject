{"changed":true,"filter":false,"title":"schema.anterior.rb","tooltip":"/Proyecto-locutores/db/schema.anterior.rb","value":"# This file is auto-generated from the current state of the database. Instead\n# of editing this file, please use the migrations feature of Active Record to\n# incrementally modify your database, and then regenerate this schema definition.\n#\n# Note that this schema.rb definition is the authoritative source for your\n# database schema. If you need to create the application database on another\n# system, you should be using db:schema:load, not running all the migrations\n# from scratch. The latter is a flawed and unsustainable approach (the more migrations\n# you'll amass, the slower it'll run and the greater likelihood for issues).\n#\n# It's strongly recommended that you check this file into your version control system.\n\nActiveRecord::Schema.define(version: 20180218042638) do\n\n  create_table \"administradors\", force: :cascade do |t|\n    t.string \"nombres\"\n    t.string \"apellidos\"\n    t.string \"email\"\n    t.string \"contrasena\"\n    t.string \"nombreEmpresa\"\n    t.datetime \"created_at\", null: false\n    t.datetime \"updated_at\", null: false\n  end\n\n  create_table \"concursos\", force: :cascade do |t|\n    t.string \"nombreConcurso\"\n    t.datetime \"fechaInicio\"\n    t.datetime \"fechaFin\"\n    t.integer \"valorPagar\"\n    t.text \"recomendaciones\"\n    t.text \"guionConcurso\"\n    t.string \"imagenBanner\"\n    t.string \"concursoURL\"\n    t.datetime \"created_at\", null: false\n    t.datetime \"updated_at\", null: false\n  end\n\n  create_table \"voces_locutors\", force: :cascade do |t|\n    t.string \"nombresLocutor\"\n    t.string \"apellidosLocutor\"\n    t.string \"emailLocutor\"\n    t.string \"originalURL\"\n    t.string \"convertidaURL\"\n    t.text \"comentarios\"\n    t.string \"estado\"\n    t.datetime \"created_at\", null: false\n    t.datetime \"updated_at\", null: false\n  end\n\nend\n","undoManager":{"mark":-1,"position":-1,"stack":[]},"ace":{"folds":[],"scrolltop":57.5,"scrollleft":0,"selection":{"start":{"row":0,"column":0},"end":{"row":0,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1519608812532}