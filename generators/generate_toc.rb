class TableOfContents

  def create

    readme = File.open("README.md", 'rb') { |f| f.read }

    start_split = "##### Existing Pages"
    end_split = "##### Generating the ebook"

    start = readme.split(start_split)[0]
    rest = readme.split(start_split)[1]
    finale = rest.split(end_split)[1]

    template = start_split + "\n\n| Topics | Last Updated | Length | \n| -------|--------------|\n"

    template = add_markdown_files_to template

    new_file = start + template + "\n" + end_split + finale
    File.open("README.md", 'w') { |f| f.write new_file }

  end

def add_markdown_files_to template
    mdfiles = []
    Dir.foreach('./chapters') do |item|
      next if item == '.' or item == '..'
      next if item[-2..-1] != "md"
      next if item == "README.md"

      mdfiles << item
    end

    mdfiles.each do |mdfile|
      title = mdfile[0..-4].gsub("_", " ").gsub(/\w+/) { |word| word.capitalize }.gsub("Ios", "iOS")
      last_updated = `git log -1  --date=short --pretty=format:"%ad" ./chapters/#{mdfile}`
      words = `wc -w ./chapters/#{mdfile}`.split(" ").first

      template += "|[#{title}](chapters/#{mdfile})|#{last_updated}|Words: #{words}|\n"
    end

    template
  end

end
