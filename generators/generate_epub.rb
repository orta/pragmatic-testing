require 'tempfile'

class Epub

  def create
    unless `which pandoc`.length > 0
      puts "Pandoc needs to be installed to generate the ePub"
      return
    end

    markdown_files = get_markdown_files
    compiled = compile_markdown_files markdown_files

    file = Tempfile.new('book')
    file.write compiled
    file.close

    `pandoc -f markdown -t epub --epub-cover-image=assets/mock_logo.png -o pragmatic_testing.epub --smart --toc --epub-stylesheet=assets/pragmatic_style.css #{file.path}`

    file.unlink
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
