require 'json'

usage       'index'
summary     'creates index for the javascript libraries'
description 'This command does a lot of stuff. I really mean a lot.'

option :o, :out, 'output directory', argument: :optional

run do |opts, args, cmd|
  output_dir = opts[:o] || 'static/assets/js'
  puts "Using #{output_dir} directory for index!"

  input_dir = 'tmp/tique-index'
  index_def = File.join(input_dir, "*.idx")
  index_files = Dir.glob(index_def)

  unless Dir.exists?(output_dir)
      Dir.mkdir(output_dir)
  end

  indexed_file = "#{output_dir}/tipuesearch_set.js"
  File.delete(indexed_file)
  File.open(indexed_file,"w+") do |file|
    start = true
    #file.write('var tipuesearch_pages = {"pages": [')
    file.write('var tipuesearch_pages = [')
    index_files.each do |index_file|
      if start 
        start = false
      else
        file.write(",")
      end
      json_text = JSON.parse(File.open(index_file){|f| f.read})
      file.write("'#{json_text['loc']}'")
    end 
    file.write('];')
    #file.write(']};')
  end
end