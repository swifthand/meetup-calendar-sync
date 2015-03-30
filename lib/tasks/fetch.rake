namespace :fetch do

  task :meetup => :environment do
    MeetupMonitor.new.apply
  end

end
