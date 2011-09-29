#coding: utf-8
module DanNet
  class Feature < ActiveRecord::Base
    belongs_to :feature_type
    belongs_to :syn_set
    delegate :name, :to => :feature_type
  end
end
