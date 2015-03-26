class EnabledGroupsQuery

  def self.call
    MeetupGroup.enabled.to_a
  end

end
