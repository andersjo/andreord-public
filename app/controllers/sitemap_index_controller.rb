#coding: utf-8
class SitemapIndexController < ApplicationController
  def show
    respond_to do |wants|
      wants.xml do 
        @sitemap_file_ids = 0..(DanNet::WordSense.count / SITEMAPS_PER_FILE)
      end
    end

  end
end
