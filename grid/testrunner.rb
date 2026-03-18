require 'rspec'
require 'capybara/rspec'
require 'selenium-webdriver'

module Grid
  class TestRunner
    BROWSERS = ['firefox', 'chrome'].freeze

    def run
      BROWSERS.each do |browser|
        setup(browser)
        yield
      end
    end

    def setup(browser)
      puts "\n\n############################"
      puts "Starting #{browser.capitalize} test run..."
      puts "############################\n\n"

      Capybara.register_driver :remote_browser do |app|
        options = Selenium::WebDriver::Options.send(browser.to_sym)

        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: "http://#{ENV['HUB_HOST']}/wd/hub",
          options: options
        )
      end
    end
  end
end

testrunner = Grid::TestRunner.new
testrunner.run do
  RSpec::Core::Runner.run ['spec']
  RSpec.clear_examples
end
