require 'json'

usage       'index'
summary     'creates index for the javascript libraries'
description 'This command does a lot of stuff. I really mean a lot.'

option :o, :out, 'output directory', argument: :optional
option :t, :type, 'type of index', argument: :optional

run do |opts, args, cmd|
  output_dir = opts[:o] || 'static/assets/js'
  puts "Using #{output_dir} directory for index!"

  type = opts[:t] || 'live'
  is_live = type == 'live'

  input_dir = 'tmp/tique-index'
  index_def = File.join(input_dir, "*.idx")
  index_files = Dir.glob(index_def)

  unless Dir.exists?(output_dir)
      Dir.mkdir(output_dir)
  end

  indexed_file = "#{output_dir}/tipuesearch_set.js"
  indexed_file = "#{output_dir}/tipuesearch_content.json" unless is_live
  
  File.delete(indexed_file) if File.exists?(indexed_file)
  File.open(indexed_file,"w+") do |file|
    start = true
    if is_live 
       file.write('var tipuesearch_pages = [')
    else 
       file.write('{"pages": [')
    end 
    index_files.each do |index_file|
      if start 
        start = false
      else
        file.write(",")
      end
      if is_live
        json_text = JSON.parse(File.open(index_file){|f| f.read})
        file.write("'#{json_text['loc']}'")
      else 
        file.write(File.open(index_file){|f| f.read})
      end
    end 
    if is_live
      file.write('];')
    else 
      file.write(']}')
    end
  end
end