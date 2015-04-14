ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/reporters/turn_again_reporter'

Minitest::Reporters.use!(Minitest::Reporters::TurnAgainReporter.new(color: true, indent: 2))

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  self.use_transactional_fixtures = true

  def stub_query(superclass = Object, callable)
    StubQuery.new(superclass, callable)
  end


  class StubQuery
    def self.new(superclass = Object, callable)
      query = Class.new(superclass) do
        def initialize(*args, &block); end
        def call(*args, &block)
          self.class.mock_result.call(*args, &block)
        end
      end

      query.instance_exec(callable) do |mock_result|
        @mock_result = mock_result
        def mock_result
          @mock_result
        end
      end

      query
    end
  end

end
