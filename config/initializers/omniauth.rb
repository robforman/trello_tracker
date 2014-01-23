Rails.application.config.middleware.use OmniAuth::Builder do
  provider :trello, ENV.fetch('TRELLO_KEY'), ENV.fetch('TRELLO_SECRET'),
    app_name: "Trello Tracker", scope: 'read,write', expiration: 'never'
end
