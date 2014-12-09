# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141125054720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrador", id: false, force: true do |t|
    t.text "correo",    null: false
    t.text "nombres",   null: false
    t.text "apellidos", null: false
  end

  add_index "administrador", ["correo"], name: "adminc", unique: true, using: :btree
  add_index "administrador", ["correo"], name: "administrador_correo_key", unique: true, using: :btree

  create_table "avion", primary_key: "idavion", force: true do |t|
    t.string  "modelo",           limit: 6, null: false
    t.text    "marca",                      null: false
    t.integer "capacidadprimera",           null: false
    t.integer "capacidadturista",           null: false
    t.string  "disponible",       limit: 1
  end

  create_table "ciuda", force: true do |t|
    t.string   "nombre"
    t.string   "pais"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ciudads", primary_key: "nombre", force: true do |t|
    t.text    "pais",        null: false
    t.integer "distancia"
    t.text    "descripcion", null: false
    t.text    "zonahora",    null: false
    t.text    "aeropuerto",  null: false
    t.text    "IATA"
  end

  create_table "horas", id: false, force: true do |t|
    t.text   "origen"
    t.text   "destino"
    t.date   "fechasalida"
    t.time   "horasalida"
    t.string "tiempo",       limit: nil
    t.date   "fechallegada"
    t.time   "horallegada"
  end

  create_table "logins", primary_key: "correo", force: true do |t|
    t.string "secreto", limit: 50, null: false
    t.string "activo",  limit: 1,  null: false
  end

  create_table "promocions", primary_key: "idpromocion", force: true do |t|
    t.float  "porcentaje",             null: false
    t.date   "fechaentrada",           null: false
    t.date   "vigencia",               null: false
    t.text   "descripcion",            null: false
    t.string "activo",       limit: 1, null: false
  end

  add_index "promocions", ["porcentaje", "fechaentrada", "vigencia"], name: "promocions_porcentaje_fechaentrada_vigencia_key", unique: true, using: :btree

  create_table "tarjeta", primary_key: "notarjeta", force: true do |t|
    t.integer "valor",                null: false
    t.integer "idusuario",            null: false
    t.string  "disponible", limit: 1, null: false
  end

  create_table "usuarios", primary_key: "idusuario", force: true do |t|
    t.text "correo",          null: false
    t.text "nombres",         null: false
    t.text "apellidopaterno", null: false
    t.text "apellidomaterno", null: false
    t.text "nacionalidad",    null: false
    t.text "genero",          null: false
    t.date "fechanacimiento", null: false
    t.text "url_imagen"
  end

  create_table "valor", primary_key: "idvalor", force: true do |t|
    t.float "costomilla", null: false
    t.date  "fecha",      null: false
    t.text  "tipomoneda", null: false
    t.text  "tipomedida", null: false
  end

  create_table "vuelos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
