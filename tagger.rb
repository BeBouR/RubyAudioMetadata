#!/bin/ruby

require 'bundler/setup'
require 'taglib'

if ARGV.empty?
  puts('USE: ruby tagger.rb music-folder[, music-folder2, [...]]')
  exit
end

ATTRIBUTES = [:artist, :album]

def recursive_tag folder, attribute_index=0, data={}
  Dir.open(folder).each do |f|
    next if f == '..' || f == '.'
    path = "#{folder}/#{f}"
    if File.directory? path
      data[ATTRIBUTES[attribute_index]] = f
      if attribute_index < ATTRIBUTES.length
        recursive_tag path, attribute_index+1, data
      else
        puts "ERROR Folder structure too deep #{path}"
      end
    elsif File.exists? path
      TagLib::FileRef.open(path) do |file|
        unless file.null?
          title = File.basename(f)
          title = title[0..title.rindex('.') -1]
          
          tag = file.tag
          tag.title = title
          tag.artist = data[:artist]
          tag.album = data[:album]
          
          puts "ERROR saving on #{path}" unless file.save
        else
          puts "ERROR opening file #{path}"
        end
      end
    else
      puts "ERROR getting #{path}"
    end
  end
end

t1 = Time.now
ARGV.each do |root|
  recursive_tag root
end
t2 = Time.now

puts "Elapsed time: #{t2 - t1} seconds"