module ActsAsRegistry

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # In testing environment we want to be able to override
    # regularly and easily in order to mock/stub behavior.
    if Rails.env.test?
      def override_default(setting, value)
        instance_variable_set "@#{setting}", value
      end

      def override_env(**overrides)
        # Override while saving current values
        overridden = overrides.each.with_object({}) do |(setting, value), hsh|
          hsh[setting] = self.send(setting)
          self.override_default(setting, value)
        end
        # Run some code
        yield
        # Restore previous values
      ensure
        overridden.each do |setting, prev_value|
          self.override_default(setting, prev_value)
        end
      end
    end
  end

end
