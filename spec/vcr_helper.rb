require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("<TRELLO_KEY>")        { ENV["TRELLO_KEY"] }
  c.filter_sensitive_data("<TRELLO_SECRET>")     { ENV["TRELLO_SECRET"] }
  c.filter_sensitive_data("<TEST_OAUTH_TOKEN>")  { ENV["TEST_OAUTH_TOKEN"] }
  c.filter_sensitive_data("<TEST_OAUTH_SECRET>") { ENV["TEST_OAUTH_SECRET"] }
  c.configure_rspec_metadata!
end

