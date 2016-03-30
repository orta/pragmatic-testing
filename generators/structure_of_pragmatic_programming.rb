MARKDOWN_FILES = %w[
  chapters/eng/what_is/what_and_why_of_the_book.md
  chapters/eng/what_is/how_can_i_be_pragmatic_with_my_testing.md

  chapters/eng/xctest/useful_terminology.md
  chapters/eng/xctest/what_is_xctest_how_does_it_work.md
  chapters/eng/xctest/types_of_testing.md
  chapters/eng/xctest/unit_testing.md
  chapters/eng/xctest/behavior_testing.md
  chapters/eng/xctest/Three_Types_of_Unit_Tests.md
  chapters/eng/xctest/test_driven_development.md
  chapters/eng/xctest/integration_testing.md
  chapters/eng/xctest/testing_terminology.md

  chapters/eng/foundations/dependency_injection.md
  chapters/eng/foundations/stubs_and_mocks.md
  chapters/eng/foundations/fakes__plus_protocols_.md

  chapters/eng/oss_libs/expanding_on_bdd_frameworks.md
  chapters/eng/oss_libs/mocking_and_stubbing__ocmock_and_ocmockito_.md
  chapters/eng/oss_libs/network_stubbing__ohttp_and_vcrurlconnection.md

  chapters/eng/setup/getting_setup.md
  chapters/eng/setup/how_i_got_started.md
  chapters/eng/setup/starting_a_new_application_and_using_tests.md
  chapters/eng/setup/introducing_tests_into_an_existing_application.md

  chapters/eng/ops/developer_operations_aka_automation.md
  chapters/eng/ops/techniques_for_keeping_testing_code_sane.md
  chapters/eng/ops/creation_of_app-centric_it_blocks.md
  chapters/eng/ops/fixtures_and_factories.md

  chapters/eng/async/dispatch_asyncs__ar_dispatch_etc.md
  chapters/eng/async/techniques_for_getting_around_async_testing.md
  chapters/eng/async/techniques_for_getting_around_async_networking.md
  chapters/eng/async/networking_in_view_controllers__network_models.md
  chapters/eng/async/animations.md
  chapters/eng/async/will_and_xctest_6.md

  chapters/eng/app_testing/techniques_for_testing_different_aspects_of_the_app.md
  chapters/eng/app_testing/views__snapshots.md
  chapters/eng/app_testing/scroll_views.md
  chapters/eng/app_testing/user_interactions.md
  chapters/eng/app_testing/ipad_and_iphone.md
  chapters/eng/app_testing/testing_delegates.md

  chapters/eng/core_data/core_data.md
  chapters/eng/core_data/core_data_migrations.md

  chapters/eng/prag_prog/making_libraries_to_get_annoying_tests_out_of_your_app.md
  chapters/eng/prag_prog/using_xcode_pragmatically.md
  chapters/eng/prag_prog/improving_xcode.md

  chapters/eng/wrap_up/books.md
  chapters/eng/wrap_up/twitter_follows.md
  chapters/eng/wrap_up/recommended_websites.md
]

def get_markdown_files
  mdfiles = []
  Dir.glob('chapters/*/*/*') do |item|
    next if item == '.' or item == '..'
    next if item[-2..-1] != "md"
    next if item == "README.md"
    mdfiles << item
  end
  mdfiles
end

