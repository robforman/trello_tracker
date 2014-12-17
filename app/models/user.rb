class User < ActiveRecord::Base
  def trello
    @trello ||= Trello::Client.new(
        consumer_key: ENV.fetch('TRELLO_KEY'),
        consumer_secret: ENV.fetch('TRELLO_SECRET'),
        oauth_token: oauth_token,
        oauth_token_secret: oauth_token_secret
    )
  end
end
