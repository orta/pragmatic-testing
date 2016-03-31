Dir["./generators/*.rb"].each {|file| require_relative file }

TableOfContents.new.create
Epub.new.create
GitBook.new.create

todos = `grep -r TODO chapters/`.strip
if todos.length
  puts "- TODOs:"
  todos.lines.each do |l|
    puts " " + l
  end
end

puts "Applied Auto Generatedness."
