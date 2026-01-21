# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    next unless defined?(Searchkick)

    Searchkick.disable_callbacks
  end

  config.after(:suite) do
    next unless defined?(Searchkick)

    Searchkick.enable_callbacks
  end
end
