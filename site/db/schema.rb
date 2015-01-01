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

ActiveRecord::Schema.define(version: 20150101022941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrador", primary_key: "correo", force: true do |t|
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

  create_table "cancelados", primary_key: "idviaje", force: true do |t|
  end

  create_table "ciudades", primary_key: "nombre", force: true do |t|
    t.text     "pais",               null: false
    t.integer  "distancia"
    t.text     "descripcion",        null: false
    t.text     "zonahora",           null: false
    t.text     "aeropuerto",         null: false
    t.text     "IATA"
    t.text     "slug"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "logins", primary_key: "correo", force: true do |t|
    t.string "secreto", limit: 50, null: false
    t.string "activo",  limit: 1,  null: false
  end

  create_table "nosotros_infos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promocion", primary_key: "idpromocion", force: true do |t|
    t.string   "codigopromocion",    null: false
    t.date     "iniciopromo",        null: false
    t.date     "finpromo",           null: false
    t.text     "ciudad",             null: false
    t.text     "descripcion",        null: false
    t.text     "slug",               null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.float    "porcentaje"
  end

  create_table "promociones", id: false, force: true do |t|
    t.integer  "idpromocion",        default: "nextval('promociones_idpromocion_seq'::regclass)", null: false
    t.string   "codigopromocion",                                                                 null: false
    t.date     "iniciopromo",                                                                     null: false
    t.date     "finpromo",                                                                        null: false
    t.text     "ciudad",                                                                          null: false
    t.text     "descripcion",                                                                     null: false
    t.text     "slug",                                                                            null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "tarjeta", primary_key: "notarjeta", force: true do |t|
    t.integer "valor",                null: false
    t.integer "idusuario",            null: false
    t.string  "disponible", limit: 1, null: false
  end

  create_table "usuarios", primary_key: "idusuario", force: true do |t|
    t.text     "correo",              null: false
    t.text     "nombres",             null: false
    t.text     "apellidopaterno",     null: false
    t.text     "apellidomaterno",     null: false
    t.text     "nacionalidad",        null: false
    t.text     "genero",              null: false
    t.date     "fechanacimiento",     null: false
    t.text     "url_imagen"
    t.text     "slug"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "usuarios", ["correo"], name: "usuarioc", unique: true, using: :btree

  create_table "valor", primary_key: "idvalor", force: true do |t|
    t.float "costomilla", null: false
    t.date  "fecha",      null: false
    t.text  "tipomoneda", null: false
    t.text  "tipomedida", null: false
  end

  add_index "valor", ["fecha"], name: "valorc", unique: true, using: :btree

  create_table "viajes", primary_key: "idviaje", force: true do |t|
    t.text    "origen",                   null: false
    t.text    "destino",                  null: false
    t.date    "fechasalida",              null: false
    t.time    "horasalida",               null: false
    t.date    "fechallegada",             null: false
    t.time    "horallegada",              null: false
    t.integer "distancia",                null: false
    t.string  "tiempo",       limit: nil, null: false
    t.float   "costoviaje",               null: false
    t.string  "realizado",    limit: 1,   null: false
    t.integer "idavion"
  end

  add_index "viajes", ["origen", "destino", "fechasalida", "horasalida"], name: "viaje_origen_destino_fechasalida_horasalida_key", unique: true, using: :btree

  create_table "vuelos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
