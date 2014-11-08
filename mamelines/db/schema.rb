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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accion", primary_key: "idaccion", force: true do |t|
    t.text "tipoaccion", null: false
  end

  add_index "accion", ["tipoaccion"], name: "accion_tipoaccion_key", unique: true, using: :btree

  create_table "avion", primary_key: "idavion", force: true do |t|
    t.string  "modelo",           limit: 6, null: false
    t.text    "marca",                      null: false
    t.integer "capacidadprimera",           null: false
    t.integer "capacidadturista",           null: false
    t.string  "disponible",       limit: 1
  end

  create_table "ciudad", primary_key: "nombre", force: true do |t|
    t.text    "pais",        null: false
    t.float   "costo",       null: false
    t.integer "tiempoviaje", null: false
  end

  create_table "historialusuario", id: false, force: true do |t|
    t.integer "idaccion", null: false
    t.text    "correo",   null: false
    t.date    "fecha",    null: false
  end

  create_table "login", primary_key: "correo", force: true do |t|
    t.string "contraseña", limit: 18, null: false
    t.string "activo",     limit: 1,  null: false
  end

  create_table "pasajero", id: false, force: true do |t|
    t.integer "dni",     default: "nextval('pasajero_dni_seq'::regclass)",     null: false
    t.integer "idviaje", default: "nextval('pasajero_idviaje_seq'::regclass)", null: false
    t.text    "clase",                                                         null: false
    t.integer "asiento",                                                       null: false
  end

  add_index "pasajero", ["idviaje", "clase", "asiento"], name: "pasajeroc1", unique: true, using: :btree

  create_table "promocion", primary_key: "idpromocion", force: true do |t|
    t.string "codigopromocion", limit: 10, null: false
    t.float  "porcentaje",                 null: false
    t.date   "fechaentrada",               null: false
    t.date   "vigencia",                   null: false
  end

  create_table "tarjetas", primary_key: "notarjeta", force: true do |t|
    t.integer "dni", default: "nextval('tarjetas_dni_seq'::regclass)", null: false
  end

  create_table "usuario", primary_key: "dni", force: true do |t|
    t.text   "correo",                    null: false
    t.text   "nombres",                   null: false
    t.text   "apellidopaterno",           null: false
    t.text   "apellidomaterno",           null: false
    t.text   "nacionalidad",              null: false
    t.string "genero",          limit: 1, null: false
    t.date   "fechanacimiento",           null: false
  end

  create_table "viaje", primary_key: "idviaje", force: true do |t|
    t.text    "origen",                                                                   null: false
    t.text    "destino",                                                                  null: false
    t.date    "fecha",                                                                    null: false
    t.text    "horasalida",                                                               null: false
    t.text    "horallegada",                                                              null: false
    t.integer "idavion",               default: "nextval('viaje_idavion_seq'::regclass)", null: false
    t.float   "costoviaje",                                                               null: false
    t.string  "realizado",   limit: 1,                                                    null: false
  end

  create_table "viajepromocion", id: false, force: true do |t|
    t.integer "idviaje",     default: "nextval('viajepromocion_idviaje_seq'::regclass)",     null: false
    t.integer "idpromocion", default: "nextval('viajepromocion_idpromocion_seq'::regclass)", null: false
  end

  add_index "viajepromocion", ["idviaje"], name: "viajepromocion_idviaje_key", unique: true, using: :btree

end
