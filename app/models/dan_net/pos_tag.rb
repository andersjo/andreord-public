#coding: utf-8
module DanNet
  class PosTag < ActiveRecord::Base
    has_many :words
  end
end
