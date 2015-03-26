module CalSync

  def self.meetup_client
    @meetup_client = RubyMeetup::ApiKeyClient
  end

end
