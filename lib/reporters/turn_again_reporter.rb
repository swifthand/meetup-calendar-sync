module Minitest
  module Reporters
    class TurnAgainReporter < BaseReporter
      include ANSI::Code
      include RelativePosition

      attr_reader :hours, :indent

      def initialize(options = {})
        @hours  = !!options.fetch(:hours, false)
        @indent = options.fetch(:indent, 2)
        super(options)
      end

      def start
        super
        puts('Started with run options %s' % options[:args])
        puts
      end

      def report
        super
        puts('Finished in %.5fs' % total_time)
        print('%d tests, %d assertions, ' % [count, assertions])
        color = failures.zero? && errors.zero? ? :green : :red
        print(send(color) { '%d failures, %d errors, ' } % [failures, errors])
        print(yellow { '%d skips' } % skips)
        puts
      end

      def record(test)
        super
        print (' ' * indent)
        print_colored_status(test)
        print format_time(test.time)
        print test.name
        puts
        if !test.skipped? && test.failure
          print_info(test.failure)
          puts
        end
      end

protected ######################################################################

      def before_suite(suite)
        puts suite
      end

      def after_suite(suite)
        puts
      end

      def format_time(t)
        if hours
          ' (%02d:%02d:%06.3f) ' % [
            t.to_i / 3600,        # hours
            (t.to_i % 3600) / 60, # mins
            t % 60,               # seconds (kept as float)
          ]
        else
          ' (%02d:%06.3f) ' % [
            (t.to_i % 3600) / 60, # mins
            t % 60                # seconds (kept as float)
          ]
        end
      end

    end
  end
end
