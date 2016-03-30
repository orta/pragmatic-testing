require_relative 'structure_of_pragmatic_programming'

class TableOfContents

  def create

    readme = File.open("README.md", 'rb') { |f| f.read }

    start_split = "##### Existing Pages"
    end_split = "##### Generating the ebook"

    start = readme.split(start_split)[0]
    rest = readme.split(start_split)[1]
    finale = rest.split(end_split)[1]

    template = start_split + "\n\n| Topics | Last Updated | Length | \n| -------|----|-----|\n"

    template = add_markdown_files_to template

    new_file = start + template + "\n" + end_split + finale
    File.open("README.md", 'w') { |f| f.write new_file }

  end

def add_markdown_files_to template
    mdfiles = get_markdown_files

    left_overs = MARKDOWN_FILES - mdfiles

    (MARKDOWN_FILES + left_overs).each do |mdfile|
      title = mdfile[0..-4].gsub("_", " ").gsub(/\w+/) { |word| word.capitalize }.gsub("Ios", "iOS").gsub("Chapters/", "")
      last_updated = `git log -1  --date=short --pretty=format:"%ad" #{mdfile}`
      words = `wc -w #{mdfile}`.split(" ").first

      template += "|[#{title}](#{mdfile})|#{last_updated}|Words: #{words}|\n"
    end

    template
  end

end
