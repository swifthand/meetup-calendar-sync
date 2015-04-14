class GroupRemoteDetailsQuery

  def self.batch_as_entities(*urlnames, client: CalSync.meetup_client.new)
    urlnames = [*urlnames].flatten
    urlnames.map.rate_limit(*CalSync.meetup_query_rate) do |urlname|
      new(urlname).as_entity
    end
  end


  attr_reader :urlname, :meetup

  def initialize(urlname, client: CalSync.meetup_client.new)
    @urlname  = urlname
    @meetup   = client
  end

  def call
    details
  end

  def details
    @details ||= fetch_details(@urlname)
  end

  def found?
    details.present? && details != :not_found
  end

  def as_entity
    @entity ||=
      if found?
        fetch_group_record
      else
        :not_found
      end
  end


private ########################################################################


  def fetch_details(urlname)
    JSON.parse(meetup.get_path("/#{urlname}"))
  rescue RuntimeError => exc
    if exc.message =~ /\A404 Not Found/
      :not_found
    else
      raise exc
    end
  end

  def fetch_group_record
    record = MeetupGroup.find_or_initialize_by(meetup_group_id: details['id'].to_s)
    record.name     = details['name']
    record.urlname  = details['urlname']
    record
  end

end
