class WebhooksController < ApplicationController
  respond_to :json

  def create
    return head(:ok) if request.head?

    webhook = TrelloWebhookAction.new(request.raw_post)
    case webhook.change_type
      when :card_list_change
        before_list = trello.find(:lists, webhook.before_list_id)
        reset_point_name(before_list)
        after_list = trello.find(:lists, webhook.after_list_id)
        reset_point_name(after_list)
    end
    render json: {success: true}
  end

  protected

  def reset_point_name(list)
    current_points = points_for(list: list)
    list.name = PointedName.new(list.name).with_points(current_points)
    list.save
  end

  def points_for(list: nil)
    cards = list.cards
    names = cards.map{ |c| c.name }
    PointCalculator.with_names(names).sum
  end

  def trello
    @trello ||= Trello::Client.new(
      consumer_key: ENV.fetch('TRELLO_KEY'),
      consumer_secret: ENV.fetch('TRELLO_SECRET'),
      oauth_token: ENV.fetch('TEST_OAUTH_TOKEN'),
      oauth_token_secret: ENV.fetch('TEST_OAUTH_TOKEN')
    )
  end
end