#coding: utf-8
module DanNet
  class FeatureType < ActiveRecord::Base
    has_many :features
  end
end
