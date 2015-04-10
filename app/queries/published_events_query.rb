class PublishedEventsQuery

  attr_reader :source_ids

  def initialize(source_ids: [])
    @source_ids = [*source_ids].flatten
  end

  def call
    published_events
  end

private ########################################################################

  def published_events
    @published_events ||= PublishedEvent.where(source_id: source_ids).all.to_a
  end

end
