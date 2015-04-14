require 'test_helper'

class GroupRemoteDetailsQueryTest < ActiveSupport::TestCase
  fixtures :meetup_groups

  # The only method we need to mock out is get_path
  class MockClient
    def get_path(path, *args)
      # URLs here are case insensitive so we will be too.
      path = path.downcase
      case path
      when "/HoustonRuby".downcase, "/Clojure-Houston-User-Group".downcase
        urlname = path[1..-1]
        File.read(File.join(Rails.root, "test/unit/queries/#{urlname}.json"))
      when "/NonExistantGroup".downcase
        response_body = "{\"errors\":[{\"code\":\"group_error\",\"message\":\"Invalid group urlname\"}]}"
        raise "404 Not Found #{response_body}"
      else
        raise Exception.new("Not valid test data. Take a closer look, please.")
      end
    end
  end


  def build_query(*args)
    GroupRemoteDetailsQuery.new(*args, client: MockClient.new)
  end


  test "fetches details from meetup" do
    query = build_query('HoustonRuby')
    assert_equal(HOUSTON_RUBY_HASH, query.call)
    # Lower-case case.
    query = build_query('clojure-houston-user-group')
    assert_equal(HOUSTON_CLOJURE_HASH, query.call)
  end


  test "indicates whether a group is found" do
    query = build_query('HoustonRuby')
    assert(query.found?)
    query = build_query('houstonruby')
    assert(query.found?)
    query = build_query('NonExistantGroup')
    refute(query.found?)
  end


  test "builds an entity from details" do
    query = build_query('Clojure-Houston-User-Group')
    assert(query.found?)
    record = MeetupGroup.new(
      meetup_group_id: "5634432",
      name: "Clojure Houston User Group",
      urlname: "Clojure-Houston-User-Group",
      enable_sync: true
    )
    assert_equal(record, query.as_entity)
  end


  test "does not persist entity build from details" do
    query = build_query('Clojure-Houston-User-Group')
    assert(query.found?)
    refute_equal(:not_found, query.as_entity)
    refute(query.as_entity.persisted?)
  end


  test "does not build an entity when group not found" do
    query = build_query('NonExistantGroup')
    refute(query.found?)
    assert_equal(:not_found, query.as_entity)
  end


  test "loads an existing record when group record exists" do
    query = build_query('HoustonRuby')
    assert(query.found?)
    record = meetup_groups(:houston_ruby)
    assert_equal(record, query.as_entity)
  end


################################################################################


HOUSTON_RUBY_HASH = {
             "id" => 4982042,
           "name" => "Houston Ruby Brigade",
           "link" => "http://www.meetup.com/HoustonRuby/",
        "urlname" => "HoustonRuby",
    "description" => "<p>Welcome to the Houston Ruby Brigade! We're for anyone looking to share or learn more about Ruby, Ruby on Rails, and Sinatra! We meet on the second Tuesday of every month in Houston (downtown area).</p>\n<p>A hyper-local Ruby meetup in the Heights area focused on help for newbies from seasoned pros.</p>\n<p><span>It does not matter whether you are just starting or whether you are a seasoned pro - all are welcome.</span></p>",
        "created" => 1347934167000,
           "city" => "Houston",
        "country" => "US",
          "state" => "TX",
      "join_mode" => "open",
     "visibility" => "public",
            "lat" => 29.760000228881836,
            "lon" => -95.36000061035156,
        "members" => 392,
            "who" => "Rubyists",
    "group_photo" => {
                  "id" => 161926842,
        "highres_link" => "http://photos2.meetupstatic.com/photos/event/b/6/f/a/highres_161926842.jpeg",
          "photo_link" => "http://photos4.meetupstatic.com/photos/event/b/6/f/a/600_161926842.jpeg",
          "thumb_link" => "http://photos2.meetupstatic.com/photos/event/b/6/f/a/thumb_161926842.jpeg"
    },
       "timezone" => "US/Central",
     "next_event" => {
          "id" => "212660642",
        "name" => "Ruby Opportunities in Houston"
    },
       "category" => {
               "id" => 34,
             "name" => "Tech",
        "shortname" => "Tech"
    },
         "photos" => [
        {             "id" => 196120232,
            "highres_link" => "http://photos1.meetupstatic.com/photos/event/9/d/2/8/highres_196120232.jpeg",
              "photo_link" => "http://photos1.meetupstatic.com/photos/event/9/d/2/8/600_196120232.jpeg",
              "thumb_link" => "http://photos1.meetupstatic.com/photos/event/9/d/2/8/thumb_196120232.jpeg"
        },
        {             "id" => 223337102,
            "highres_link" => "http://photos3.meetupstatic.com/photos/event/4/2/c/e/highres_223337102.jpeg",
              "photo_link" => "http://photos3.meetupstatic.com/photos/event/4/2/c/e/600_223337102.jpeg",
              "thumb_link" => "http://photos3.meetupstatic.com/photos/event/4/2/c/e/thumb_223337102.jpeg"
        },
        {             "id" => 246959412,
            "highres_link" => "http://photos4.meetupstatic.com/photos/event/e/8/1/4/highres_246959412.jpeg",
              "photo_link" => "http://photos2.meetupstatic.com/photos/event/e/8/1/4/600_246959412.jpeg",
              "thumb_link" => "http://photos2.meetupstatic.com/photos/event/e/8/1/4/thumb_246959412.jpeg"
        },
        {             "id" => 257928502,
            "highres_link" => "http://photos1.meetupstatic.com/photos/event/b/d/7/6/highres_257928502.jpeg",
              "photo_link" => "http://photos1.meetupstatic.com/photos/event/b/d/7/6/600_257928502.jpeg",
              "thumb_link" => "http://photos1.meetupstatic.com/photos/event/b/d/7/6/thumb_257928502.jpeg"
        }
    ]
}


HOUSTON_CLOJURE_HASH = {
             "id" => 5634432,
           "name" => "Clojure Houston User Group",
           "link" => "http://www.meetup.com/Clojure-Houston-User-Group/",
        "urlname" => "Clojure-Houston-User-Group",
    "description" => "<p>Clojure is an awesome programming language for the JVM. Come join us monthly for teaching each other Clojure and libraries, presenting ongoing work, and looking for Clojure work opportunities</p>",
        "created" => 1351646616000,
           "city" => "Houston",
        "country" => "US",
          "state" => "TX",
      "join_mode" => "open",
     "visibility" => "public",
            "lat" => 29.760000228881836,
            "lon" => -95.36000061035156,
        "members" => 78,
            "who" => "Clojurians",
    "group_photo" => {
                  "id" => 228834332,
        "highres_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/highres_228834332.jpeg",
          "photo_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/600_228834332.jpeg",
          "thumb_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/thumb_228834332.jpeg"
    },
       "timezone" => "US/Central",
     "next_event" => {
          "id" => "221282338",
        "name" => "Monthly meetup - TBD"
    },
       "category" => {
               "id" => 34,
             "name" => "Tech",
        "shortname" => "Tech"
    },
         "photos" => [
        {             "id" => 228834332,
            "highres_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/highres_228834332.jpeg",
              "photo_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/600_228834332.jpeg",
              "thumb_link" => "http://photos1.meetupstatic.com/photos/event/d/4/3/c/thumb_228834332.jpeg"
        }
    ]
}



end
