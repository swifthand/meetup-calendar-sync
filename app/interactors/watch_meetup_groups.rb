class WatchMeetupGroups

  attr_reader :group_names

  def initialize(*group_names)
    @group_names = [*group_names].flatten
  end

  def apply
    GroupRemoteDetailsQuery.batch_as_entities(group_names).map(&:save)
  end

end
