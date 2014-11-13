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

ActiveRecord::Schema.define(version: 20141109205812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avions", primary_key: "idavion", force: true do |t|
    t.string  "modelo",           limit: 6, null: false
    t.text    "marca",                      null: false
    t.integer "capacidadprimera",           null: false
    t.integer "capacidadturista",           null: false
    t.string  "disponible",       limit: 1
  end

  create_table "ciudad", primary_key: "nombre", force: true do |t|
    t.text    "pais",        null: false
    t.integer "distancia"
    t.text    "descripcion", null: false
    t.text    "zonahora",    null: false
    t.text    "aeropuerto",  null: false
  end

  create_table "logins", primary_key: "correo", force: true do |t|
    t.string "contraseña", limit: 18, null: false
    t.string "activo",     limit: 1,  null: false
  end

  create_table "promocion", primary_key: "idpromocion", force: true do |t|
    t.float "porcentaje",   null: false
    t.date  "fechaentrada", null: false
    t.date  "vigencia",     null: false
  end

  add_index "promocion", ["porcentaje", "fechaentrada", "vigencia"], name: "promocion_porcentaje_fechaentrada_vigencia_key", unique: true, using: :btree

  create_table "promocions", primary_key: "idpromocion", force: true do |t|
    t.string "codigopromocion", limit: 10, null: false
    t.float  "porcentaje",                 null: false
    t.date   "fechaentrada",               null: false
    t.date   "vigencia",                   null: false
  end

  create_table "tarjeta", primary_key: "notarjeta", force: true do |t|
    t.integer "idusuario",                          null: false
    t.integer "valor"
    t.decimal "saldo",     precision: 10, scale: 2
  end

  create_table "usuarios", primary_key: "idusuario", force: true do |t|
    t.text   "correo",                    null: false
    t.text   "nombres",                   null: false
    t.text   "apellidopaterno",           null: false
    t.text   "apellidomaterno",           null: false
    t.text   "nacionalidad",              null: false
    t.string "genero",          limit: 1, null: false
    t.date   "fechanacimiento",           null: false
    t.text   "url_imagen"
  end

  create_table "valor", primary_key: "idvalor", force: true do |t|
    t.float "costomilla", null: false
    t.text  "tipomoneda", null: false
    t.text  "tipomedida", null: false
  end

  create_table "viaje", primary_key: "idviaje", force: true do |t|
    t.text    "origen",                   null: false
    t.text    "destino",                  null: false
    t.date    "fechasalida",              null: false
    t.time    "horasalida",               null: false
    t.date    "fechallegada"
    t.time    "horallegada"
    t.integer "distancia"
    t.integer "idavion",                  null: false
    t.float   "costoviaje"
    t.string  "realizado",    limit: 1,   null: false
    t.string  "tiempo",       limit: nil
  end

end
