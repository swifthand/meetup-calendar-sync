module GoogleCalendarGateway
  class CredentialsRecordStore

    def initialize(record: nil)
      @record = record || fetch_record
    end


    def write_credentials(credentials_hash)
      record.update_attributes(value: credentials_hash)
    end


    def read_credentials
      HashWithIndifferentAccess.new(record.value)
    end

private ########################################################################

    attr_reader :record

    def fetch_record
      result = Setting.where(key: 'google_calendar_credentials').first_or_initialize
    end

  end
end
