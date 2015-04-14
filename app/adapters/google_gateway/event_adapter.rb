# Presently, we ignore options for tags and group
module GoogleGateway
  class EventAdapter < CalendarAdapters::EventAdapter

    attr_reader :auth, :api

    def initialize(auth: , api: GoogleGateway.calendar_api)
      @auth = auth
      @api  = api
    end


    def create(event_dto)
      response = GoogleGateway.execute(
        api_method:     api.events.insert,
        authorization:  auth,
        headers:        request_headers,
        parameters:     { 'calendarId' => evt.calendar_id },
        body_object:    body_from_dto(event_dto),
      )
      case response.status
      when 200...300
        success_dto(response.data.to_hash)
      else
        failure_dto(response.data.to_hash)
      end
    end


    def update(event_dto)
      response = GoogleGateway.execute(
        api_method:     api.events.insert,
        authorization:  auth,
        headers:        request_headers,
        parameters:     {
          'calendarId'  => evt.calendar_id,
          'eventId'     => evt.destination_id
        },
        body_object:    body_from_dto(event_dto),
      )
      case response.status
      when 200...300
        success_dto(request_evt, response.data.to_hash)
      else
        failure_dto(request_evt, response.data.to_hash)
      end
    end


    def success_dto(request_evt, result)
      CalendarAdapters::EventDTO.success(
        source_id:        request_evt.source_id,
        destination_id:   result['id'],
        calendar_id:      request_evt.calendar_id,
        start_time:       result.fetch('start', {})['dateTime'],
        end_time:         result.fetch('end', {})['dateTime'],
        all_day:          false,
        name:             result['summary'],
        description:      result['description'],
        group:            request_evt.group,
        source_url:       result.fetch('source', {})['url'],
        destination_url:  result['htmlLink'],
        location:         result['location'],
        tags:             request_evt.tags,
        last_update:      result['updated'],
        details:          result, # Keep this around for good measure.
      )
    end

    def failure_dto(request_evt, result)
      CalendarAdapters::EventDTO.failure(
        # TODO
      )
    end


    def request_headers
      {'Content-Type' => 'application/json'}
    end


    def body_from_dto(evt)
      { 'kind'        => 'calendar#event',
        'end'         => { 'dateTime' => evt.end_time.to_datetime.iso8601 },
        'start'       => { 'dateTime' => evt.start_time.to_datetime.iso8601 },
        'summary'     => evt.name,
        'source'      => { 'url' => evt.source_url },
        'description' => evt.description,
        'location'    => evt.location,
      }
    end

  end
end
