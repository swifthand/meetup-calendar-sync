# DEPRECATED:
# This code is ripped directly from another project for temporary use
# until it can be integrated into the Bifrost Gem and utilized from there.
# I haven't even copied over the test code.
# Please do not extend or depend on it beyond what you already find here.
#
# Love,
# Swifthand
#
module CalendarAdapters
  class TransactionalDTO

    def self.attribute(name)
      self.attribute_list << name
      define_method(name) do
        self.attributes.fetch(name) do
          raise NameError.new("Attribute '#{name}' not set for #{self}")
        end
      end
    end

    def self.attribute_list
      @attribute_list ||= []
    end

    def self.request(*args, errors: [], **attributes)
      self.new(*args, processed: false, errors: [], **attributes)
    end

    def self.response(*args, errors: , **attributes)
      self.new(*args, processed: true, errors: errors, **attributes)
    end

    def self.success(*args, **attributes)
      self.response(*args, errors: [], **attributes)
    end

    def self.failure(*args, errors: [], **attributes)
      errors << "Unspecified error" if errors.empty?
      self.response(*args, errors: errors, **attributes)
    end


    attr_reader :attributes, :errors

    def initialize(processed: , errors: , **attributes)
      @processed  = !!processed
      @errors     = errors
      @attributes = HashWithIndifferentAccess.new(attributes.slice(*self.class.attribute_list))
    end


    def processed?
      @processed
    end
    alias_method :response?, :processed?


    def request?
      !@processed
    end


    def success?
      errors.empty?
    end


    def failure?
      errors.any?
    end


    def [](key)
      attributes[key]
    end


    def provided?(*attr_names)
      attr_names.all? { |attr_name| @attributes.key?(attr_name) }
    end


    def required!(*attr_names)
      not_found = attr_names.reject { |attr_name| @attributes.key?(attr_name) }
      if not_found.empty?
        true
      else
        raise NameError.new(
          "Required attributes [#{not_found.join(', ')}] not set for #{self}")
      end
    end


    def ==(other_dto)
      self.attributes == other_dto.attributes &&
      self.processed? == other_dto.processed? &&
      self.errors     == other_dto.errors
    end

  end
end
