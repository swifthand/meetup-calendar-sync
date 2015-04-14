module GoogleGateway
  class CalendarAdapter < CalendarAdapters::CalendarAdapter

    attr_reader :auth, :api

    def initialize(auth: , api: GoogleGateway.calendar_api)
      @auth = auth
      @api  = api
    end


    def list
      result = GoogleGateway.execute(
        api_method: api.calendar_list.list,
        authorization: auth
      )
      result.data.to_hash.fetch('items', []).map do |cal|
        CalendarAdapters::CalendarDTO.success(
          id:           cal['id'],
          summary:      cal['summary'],
          description:  cal['description'],
          **role_as_permissions(cal['accessRole'])
        )
      end
    end

    # Returns read, write, admin
    def role_as_permissions(role)
      case role
      when 'freeBusyReader'
        { read_access:  false,
          write_access: false,
          admin_access: false,
        }
      when 'reader'
        { read_access:  true,
          write_access: false,
          admin_access: false,
        }
      when 'writer'
        { read_access:  true,
          write_access: true,
          admin_access: false,
        }
      when 'owner'
        { read_access:  true,
          write_access: true,
          admin_access: true,
        }
      end
    end

  end
end
