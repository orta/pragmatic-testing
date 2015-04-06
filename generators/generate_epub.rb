require 'tempfile'

class Epub

  def create
    unless `which pandoc`.length > 0
      puts "Pandoc needs to be installed to generate the ePub"
      return
    end

    markdown_files = %w[
      chapters/what_and_why_of_the_book.md
      
      chapters/what_is_xctest_how_does_it_work.md
      chapters/how_can_i_be_pragmatic_with_my_testing.md
      
      chapters/types_of_testing.md
      chapters/unit_testing.md
      chapters/behavior_testing.md
      chapters/integration_testing.md
      chapters/useful_terminology.md
      chapters/testing_terminology.md
      
      chapters/di.md
      chapters/dependency_injection.md
      chapters/stubs_and_mocks.md
      chapters/fakes__plus_protocols_.md
      
      chapters/tooling_for_the_types_of_testing.md
      chapters/unit_testing__specta_and_kiwi_.md
      chapters/Three_Types_of_Unit_Tests.md
      chapters/mocking_and_stubbing__ocmock_and_ocmockito_.md
      chapters/network_stubbing__ohttp_and_vcrurlconnection.md
      
      chapters/getting_setup.md
      chapters/how_i_got_started.md

      chapters/starting_a_new_application_and_using_tests.md      
      chapters/introducing_tests_into_an_existing_application.md

      chapters/developer_operations_aka_automation.md
      chapters/techniques_for_keeping_testing_code_sane.md
      
      chapters/nested_before_and_after_usage.md
      chapters/creation_of_app-centric_it_blocks.md
      chapters/fixtures_and_factories.md
      
      chapters/networking_in_view_controllers__network_models.md
      chapters/animations.md
      
      chapters/techniques_for_getting_around_async_testing.md
      chapters/dispatch_asyncs__ar_dispatch_etc.md
      chapters/will_and_xctest_6.md
      
      chapters/techniques_for_testing_different_aspects_of_the_app.md
      chapters/views__snapshots.md
      chapters/scroll_views.md
      chapters/user_interactions.md
      chapters/ipad_and_iphone.md

      chapters/core_data.md
      chapters/assert_on_accessing_main_context.md
      chapters/stubbed_core_data_contexts.md
      chapters/core_data_migrations.md

      chapters/making_libraries_to_get_annoying_tests_out_of_your_app.md
      chapters/using_xcode_pragmatically.md
      chapters/improving_xcode.md
      
      chapters/expanding_on_specta_and_expecta.md
      chapters/test_driven_development.md
      
      chapters/swift.md
      chapters/books.md
      chapters/twitter_follows.md
      chapters/recommended_websites.md
      chapters/oss_testing_in_ios.md
      chapters/restkit_plus_afnetworking.md
      chapters/moya_and_eidolon.md
    ]

    all_markdown = get_markdown_files
    diff = (markdown_files|all_markdown) - (markdown_files & all_markdown)
    if diff.length > 0
      puts "Looks like #{diff.join(", ")} is/are missing."
    end

    `pandoc -f markdown -t epub --epub-cover-image=assets/Cover.png -o pragmatic_testing.epub --smart --toc --epub-stylesheet=assets/pragmatic_style.css #{ markdown_files.join(" " )}`
  end

  def get_markdown_files
    mdfiles = []
    Dir.foreach('./chapters') do |item|
      next if item == '.' or item == '..'
      next if item[-2..-1] != "md"
      next if item == "README.md"

      mdfiles << "chapters/" + item
    end
    mdfiles
  end

end
