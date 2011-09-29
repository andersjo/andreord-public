#coding: utf-8
# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "dn_feature_types", :force => true do |t|
    t.text "name", :null => false
  end

  add_index "dn_feature_types", ["id"], :name => "dn_feature_types_id_key", :unique => true

  create_table "dn_features", :force => true do |t|
    t.integer "syn_set_id",      :limit => 8, :null => false
    t.integer "feature_type_id",              :null => false
  end

  create_table "dn_pos_tags", :force => true do |t|
    t.text "name", :null => false
  end

  add_index "dn_pos_tags", ["id"], :name => "dn_pos_tags_id_key", :unique => true

  create_table "dn_relation_types", :force => true do |t|
    t.text    "name",          :null => false
    t.text    "word_net_name", :null => false
    t.integer "reverse_id"
  end

  add_index "dn_relation_types", ["id"], :name => "dn_relation_types_id_key", :unique => true
  add_index "dn_relation_types", ["reverse_id"], :name => "dn_relation_types_reverse_id_key", :unique => true

  create_table "dn_relations", :force => true do |t|
    t.integer "relation_type_id",                 :null => false
    t.text    "target_word_net_id"
    t.integer "syn_set_id",          :limit => 8, :null => false
    t.boolean "taxonomic"
    t.text    "inheritance_comment"
    t.integer "target_syn_set_id",   :limit => 8
  end

  create_table "dn_syn_sets", :force => true do |t|
    t.text "label", :null => false
    t.text "gloss"
    t.text "usage"
  end

  add_index "dn_syn_sets", ["id"], :name => "dn_syn_sets_id_key", :unique => true

  create_table "dn_word_senses", :force => true do |t|
    t.integer "word_id",    :limit => 8, :null => false
    t.integer "syn_set_id", :limit => 8, :null => false
    t.text    "register",                :null => false
  end

  add_index "dn_word_senses", ["id"], :name => "dn_word_senses_id_key", :unique => true

  create_table "dn_words", :force => true do |t|
    t.text    "lemma",      :null => false
    t.integer "pos_tag_id", :null => false
  end

  add_index "dn_words", ["id"], :name => "dn_words_id_key", :unique => true

  add_foreign_key "dn_features", ["syn_set_id"], "dn_syn_sets", ["id"], :name => "dn_features_syn_set_id"
  add_foreign_key "dn_features", ["feature_type_id"], "dn_feature_types", ["id"], :name => "dn_features_feature_type_id"

  add_foreign_key "dn_relation_types", ["reverse_id"], "dn_relation_types", ["reverse_id"], :name => "dn_relation_types_reverse_id"

  add_foreign_key "dn_relations", ["relation_type_id"], "dn_relation_types", ["id"], :name => "dn_relations_relation_type_id"
  add_foreign_key "dn_relations", ["syn_set_id"], "dn_syn_sets", ["id"], :name => "dn_relations_syn_set_id"
  add_foreign_key "dn_relations", ["target_syn_set_id"], "dn_syn_sets", ["id"], :name => "dn_relations_target_syn_set_id"

  add_foreign_key "dn_word_senses", ["syn_set_id"], "dn_syn_sets", ["id"], :name => "d_word_senses_syn_set_id"
  add_foreign_key "dn_word_senses", ["word_id"], "dn_words", ["id"], :name => "dn_word_senses_word_id"

  add_foreign_key "dn_words", ["pos_tag_id"], "dn_pos_tags", ["id"], :name => "dn_words_pos_tag_id"

end
