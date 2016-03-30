require 'tempfile'
require_relative 'structure_of_pragmatic_programming'

class GitBook

  def create
    markdown_files = MARKDOWN_FILES

    body = "### Summary\n\n"

    markdown_files.each do |path|
      title = path[0..-4].gsub("_", " ").gsub(/\w+/) { |word| word.capitalize }.gsub("Ios", "iOS")

      body += "* [#{title}](#{path})\n"
    end

    File.open("SUMMARY.md", 'w') { |f| f.write body }
    File.open("gitbook_summary.md", 'w') { |f|
      file = File.read("chapters/eng/what_is/what_and_why_of_the_book.md")
      f.write file
    }

  end
end
