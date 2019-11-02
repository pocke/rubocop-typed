require "rubocop/typed/version"

module RuboCop
  module Typed
    class Error < StandardError; end
    # Your code goes here...
    PROJECT_ROOT   = Pathname.new(__dir__).parent.parent.expand_path.freeze
    CONFIG_DEFAULT = PROJECT_ROOT.join('config', 'default.yml').freeze
    CONFIG         = YAML.safe_load(CONFIG_DEFAULT.read).freeze

    private_constant(:CONFIG_DEFAULT, :PROJECT_ROOT)

    def self.init_steep_project
      @driver = SteepDriver.new
      @driver.init_project
    end

    def self.driver
      @driver
    end
  end
end

