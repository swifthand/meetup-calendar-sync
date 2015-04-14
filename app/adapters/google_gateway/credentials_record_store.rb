module GoogleGateway
  class CredentialsRecordStore

    DEFAULT_KEY = 'google_calendar_credentials'

    delegate  :value, :to => :@record

    def initialize(key = nil, record: nil)
      @record = record || fetch_record(key)
    end


    def write_credentials(credentials_hash)
      record.update_attributes(value: credentials_hash)
    end


    def load_credentials
      HashWithIndifferentAccess.new(record.value)
    end

private ########################################################################

    attr_reader :record

    def fetch_record(key)
      # TODO: Less coupled to Settings Record?
      result = Setting.where(key: (key || DEFAULT_KEY)).first_or_initialize
    end

  end
end
