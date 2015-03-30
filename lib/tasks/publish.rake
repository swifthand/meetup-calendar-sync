namespace :publish do

  task :google_calendar => :environment do
    PublishEvents.new.apply
  end

end
