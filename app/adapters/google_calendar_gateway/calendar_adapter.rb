module GoogleCalendarGateway
  class CalendarAdapter

    attr_reader :auth, :api

    def initialize(auth: , api: GoogleCalendarGateway.calendar_api)
      @auth = auth
      @api  = api
    end


    def list
      result = GoogleCalendarGateway.execute(
        api_method: api.calendar_list.list,
        authorization: auth
      )
      result.data.to_hash.fetch('items', []).map do |cal|
        CalendarDTO.success(
          id:           cal['id'],
          summary:      cal['summary'],
          description:  cal['description'],
          access_role:  cal['accessRole']
        )
      end
    end

  end
end
