require "rspec"
require "rspec/its"

require "simplecov"

require "factory_bot"
require "timecop"

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a
    # real object. This is generally recommended, and will default to `true` in
    # RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.include DeclarationMatchers

  config.before do
    FactoryBot.reload
  end

  config.after do
    Timecop.return
  end

  config.around do |example|
    begin
      previous_use_parent_strategy = FactoryBot.use_parent_strategy
      previous_automatically_define_enum_traits =
        FactoryBot.automatically_define_enum_traits
      example.run
    ensure
      FactoryBot.use_parent_strategy = previous_use_parent_strategy
      FactoryBot.automatically_define_enum_traits =
        previous_automatically_define_enum_traits
    end
  end

  config.order = :random
  Kernel.srand config.seed

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
end
