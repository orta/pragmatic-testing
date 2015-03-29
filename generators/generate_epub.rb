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
      how_can_i_be_pragmatic.md
      how_i_got_started.md
      useful_terminology.md
      types_of_testing.md
      Three_Types_of_Unit_Tests.md 
      getting_setup.md
      Tooling_for_different_types_of_testing.md
      developer_operations.md
      introducing_tests_into_an_existing_app.md
      dependency_injection.md 
      testing_delegates.md 
      Techniques_for_avoiding_Async_Testing.md 
      core_data_migrations.md
      stubbed_core_data.md
      recommended_websites.md
    ]

    all_markdown = get_markdown_files
    diff = (markdown_files|all_markdown) - (markdown_files & all_markdown)
    if diff.length > 0
      puts "Looks like #{diff.join(" ")} is/are missing."
    end

    `pandoc -f markdown -t epub --epub-cover-image=assets/mock_logo.png -o pragmatic_testing.epub --smart --toc --epub-stylesheet=assets/pragmatic_style.css #{ markdown_files.join(" " )}`
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

end
