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

ActiveRecord::Schema.define(version: 2018_11_27_002906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "actuator_logs", force: :cascade do |t|
    t.bigint "actuator_id"
    t.datetime "moment"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actuator_id"], name: "index_actuator_logs_on_actuator_id"
  end

  create_table "actuators", force: :cascade do |t|
    t.string "name"
    t.string "serial"
    t.bigint "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "environment_id"
    t.index ["environment_id"], name: "index_actuators_on_environment_id"
    t.index ["unit_type_id"], name: "index_actuators_on_unit_type_id"
  end

  create_table "actuators_devices", force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "actuator_id"
    t.index ["actuator_id"], name: "index_actuators_devices_on_actuator_id"
    t.index ["device_id"], name: "index_actuators_devices_on_device_id"
  end

  create_table "device_logs", force: :cascade do |t|
    t.bigint "device_id"
    t.datetime "moment"
    t.boolean "status"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_logs_on_device_id"
  end

  create_table "device_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "specifications"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.string "serial"
    t.text "description"
    t.bigint "device_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_type_id"], name: "index_devices_on_device_type_id"
  end

  create_table "devices_interfaces", force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "interface_id"
    t.index ["device_id"], name: "index_devices_interfaces_on_device_id"
    t.index ["interface_id"], name: "index_devices_interfaces_on_interface_id"
  end

  create_table "devices_sensors", force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "sensor_id"
    t.index ["device_id"], name: "index_devices_sensors_on_device_id"
    t.index ["sensor_id"], name: "index_devices_sensors_on_sensor_id"
  end

  create_table "environment_rooms", force: :cascade do |t|
    t.bigint "environment_id"
    t.bigint "room_id"
    t.string "name"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["environment_id"], name: "index_environment_rooms_on_environment_id"
    t.index ["room_id"], name: "index_environment_rooms_on_room_id"
  end

  create_table "environments", force: :cascade do |t|
    t.string "name"
    t.bigint "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_type_id"], name: "index_environments_on_unit_type_id"
  end

  create_table "floors", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interfaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "network_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_id"], name: "index_interfaces_on_network_id"
  end

  create_table "networks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "configuration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "floor_id"
    t.string "name"
    t.text "sizes"
    t.text "position"
    t.text "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["floor_id"], name: "index_rooms_on_floor_id"
  end

  create_table "sensor_logs", force: :cascade do |t|
    t.bigint "sensor_id"
    t.datetime "moment"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_sensor_logs_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "name"
    t.string "serial"
    t.bigint "unit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "environment_id"
    t.index ["environment_id"], name: "index_sensors_on_environment_id"
    t.index ["unit_type_id"], name: "index_sensors_on_unit_type_id"
  end

  create_table "unit_types", force: :cascade do |t|
    t.string "description"
    t.string "unit"
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "actuators", "environments"
  add_foreign_key "actuators_devices", "actuators"
  add_foreign_key "actuators_devices", "devices"
  add_foreign_key "devices", "device_types"
  add_foreign_key "devices_interfaces", "devices"
  add_foreign_key "devices_interfaces", "interfaces"
  add_foreign_key "devices_sensors", "devices"
  add_foreign_key "devices_sensors", "sensors"
  add_foreign_key "environment_rooms", "environments"
  add_foreign_key "environment_rooms", "rooms"
  add_foreign_key "environments", "unit_types"
  add_foreign_key "interfaces", "networks"
  add_foreign_key "rooms", "floors"
  add_foreign_key "sensors", "environments"
end
