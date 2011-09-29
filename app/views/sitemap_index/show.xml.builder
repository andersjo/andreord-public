xml.instruct!
xml.sitemapindex "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @sitemap_file_ids.each do |id|
    xml.sitemap do
      xml.loc sitemap_path(id, :only_path => false, :format => 'xml')
    end
  end
end