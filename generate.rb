Dir["./generators/*.rb"].each {|file| require_relative file }

TableOfContents.new.create
Epub.new.create
GitBook.new.create

puts "Applied Auto Generatedness."
