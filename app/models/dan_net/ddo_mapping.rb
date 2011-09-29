#coding: utf-8
module DanNet
  class DdoMapping < ActiveRecord::Base
    belongs_to :word_sense
  end
end
