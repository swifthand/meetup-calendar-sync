namespace :cleanup do

  task :default => :environment do
    CleanupPastEvents.new.apply
  end

end
