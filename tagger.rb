#!/bin/ruby

if ARGV.empty?
  puts('USE: ruby tagger.rb music-folder[, music-folder2, [...]]')
  exit
end

ATTRIBUTES = [:artist, :album]

def recursive_tag folder, attribute_index=0, data=[]
  Dir.open(folder).each do |f|
    next if f == '..' || f == '.'
    path = "#{folder}/#{f}"
    if File.directory? path
      recursive_tag path, attribute_index+1, data + [f]
    elsif File.exists? path
      puts "#{path}: {\n\t" + ATTRIBUTES.collect.with_index {|a,i| "#{a}: #{data[i]}"}.join(",\n\t") + ",\n\ttitle: #{File.basename path}\n}\n\n"
    else
      puts 'ERROR'
    end
  end
end

ARGV.each do |root|
  recursive_tag root
end

puts '== End =='