require 'tempfile'

class Epub

  def create
    unless `which pandoc`.length > 0
      puts "Pandoc needs to be installed to generate the ePub"
      return
    end

    markdown_files = %w[
      what_and_why.md
      what_is_xctest.md
      how_can_I_be_pragmatic.md
      getting_setup.md
      recommended_websites.md
      Core-Data-Migrations.md
    ]

    all_markdown = get_markdown_files

    diff = (markdown_files|all_markdown) - (markdown_files & all_markdown)
    if diff.length > 0
      puts "Looks like #{diff.join(" ")} is/are missing."
    end

    `pandoc -f markdown -t epub --epub-cover-image=assets/mock_logo.png -o pragmatic_testing.epub --smart --toc --epub-stylesheet=assets/pragmatic_style.css #{ markdown_files.join(" " )}`

    # file.unlink
  end

  def get_markdown_files
    mdfiles = []
    Dir.foreach('.') do |item|
      next if item == '.' or item == '..'
      next if item[-2..-1] != "md"
      next if item == "README.md"

      mdfiles << item
    end
    mdfiles
  end

  def compile_markdown_files files
      compiled = ""
      files.each do |file|
        compiled += File.read(file)
      end
      compiled
  end

end
