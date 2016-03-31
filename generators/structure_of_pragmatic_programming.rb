MARKDOWN_FILES = %w[
  chapters/en-UK/what_is/what_and_why_of_the_book.md
  chapters/en-UK/what_is/how_can_i_be_pragmatic_with_my_testing.md

  chapters/en-UK/xctest/what_is_xctest_how_does_it_work.md
  chapters/en-UK/xctest/types_of_testing.md
  chapters/en-UK/xctest/unit_testing.md
  chapters/en-UK/xctest/behavior_testing.md
  chapters/en-UK/xctest/Three_Types_of_Unit_Tests.md
  chapters/en-UK/xctest/test_driven_development.md
  chapters/en-UK/xctest/integration_testing.md

  chapters/en-UK/foundations/dependency_injection.md
  chapters/en-UK/foundations/stubs_mocks_and_fakes.md

  chapters/en-UK/oss_libs/expanding_on_bdd_frameworks.md
  chapters/en-UK/oss_libs/mocking_and_stubbing__ocmock_and_ocmockito_.md
  chapters/en-UK/oss_libs/network_stubbing__ohttp_and_vcrurlconnection.md

  chapters/en-UK/setup/getting_setup.md
  chapters/en-UK/setup/how_i_got_started.md
  chapters/en-UK/setup/starting_a_new_application_and_using_tests.md
  chapters/en-UK/setup/introducing_tests_into_an_existing_application.md

  chapters/en-UK/ops/developer_operations_aka_automation.md
  chapters/en-UK/ops/techniques_for_keeping_testing_code_sane.md
  chapters/en-UK/ops/creation_of_app-centric_it_blocks.md
  chapters/en-UK/ops/fixtures_and_factories.md

  chapters/en-UK/async/dispatch_asyncs__ar_dispatch_etc.md
  chapters/en-UK/async/techniques_for_getting_around_async_testing.md
  chapters/en-UK/async/techniques_for_getting_around_async_networking.md
  chapters/en-UK/async/networking_in_view_controllers__network_models.md
  chapters/en-UK/async/animations.md
  chapters/en-UK/async/will_and_xctest_6.md

  chapters/en-UK/app_testing/techniques_for_testing_different_aspects_of_the_app.md
  chapters/en-UK/app_testing/views__snapshots.md
  chapters/en-UK/app_testing/scroll_views.md
  chapters/en-UK/app_testing/user_interactions.md
  chapters/en-UK/app_testing/ipad_and_iphone.md
  chapters/en-UK/app_testing/testing_delegates.md

  chapters/en-UK/core_data/core_data.md
  chapters/en-UK/core_data/core_data_migrations.md

  chapters/en-UK/prag_prog/making_libraries_to_get_annoying_tests_out_of_your_app.md
  chapters/en-UK/prag_prog/using_xcode_pragmatically.md
  chapters/en-UK/prag_prog/improving_xcode.md

  chapters/en-UK/wrap_up/books.md
  chapters/en-UK/wrap_up/twitter_follows.md
  chapters/en-UK/wrap_up/recommended_websites.md
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

