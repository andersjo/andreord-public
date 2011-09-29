xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  for word_sense in @word_senses
    xml.url do
      xml.loc ord_path(word_sense, :only_path => false)
    end
  end
end