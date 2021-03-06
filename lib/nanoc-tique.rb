require 'nokogiri'
require 'redcarpet'

class SearchFilter < Nanoc::Filter
  identifier :search
  type :text

  def initialize(hash = {})
    super
    @tmp_index = 'tmp/tique-index'
  end

  # Index all pages except pages matching any value in config[:indextank][:excludes]
  # The main content from each page is extracted and indexed at indextank.com
  # The doc_id of each indextank document will be the absolute url to the resource without domain name
  def run(content, params={})
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, space_after_headers: true)
    page_text = extract_text(markdown.render(item.raw_content))
    title = item[:title] || item.identifier
    file_name = item.identifier.to_s.gsub(/\//,'_')
    puts "Indexing page: #{@item.identifier} to #{@tmp_index}/#{file_name}.idx"
    unless Dir.exists?(@tmp_index)
        Dir.mkdir(@tmp_index)
    end



    idx_file_name = "#{@tmp_index}/#{file_name}.idx"
    if File.exists?(idx_file_name)
      File.delete(idx_file_name)
    end
    File.open(idx_file_name,"w+") do |file|
      file.write({title: title, text: page_text, tags: "api", loc: @item.path }.to_json)
    end
    content
  end

  def extract_text(content)
    doc = Nokogiri::HTML(content)
    doc.xpath('//*/text()').to_a.join(" ").gsub("\r"," ").gsub("\n"," ")
  end

end