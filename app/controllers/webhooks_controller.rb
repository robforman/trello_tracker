class WebhooksController < ApplicationController
  skip_before_filter :ensure_current_user, only: [:create]
  respond_to :json

  def index
    trello = build_trello_client(current_user)
    token = trello.find(:token, current_user.oauth_token, webhooks: true)
    @webhooks = token.webhooks
  end

  def create
    user = User.find(params[:user_id])
    return head(:ok) if request.head? || request.get?

    trello = build_trello_client(user)
    webhook = TrelloWebhookAction.new(request.raw_post)
    Rails.logger.info("Received webhook.change_type of '#{webhook.change_type}'")
    case webhook.change_type
      when :card_list_change
        before_list = trello.find(:lists, webhook.before_list_id)
        reset_point_name(before_list)
        after_list = trello.find(:lists, webhook.after_list_id)
        reset_point_name(after_list)
      when :card_name_change
        card = trello.find(:cards, webhook.card_id)
        current_list = card.list
        reset_point_name(current_list)
      when :archive_card
        card = trello.find(:cards, webhook.card_id)
        current_list = card.list
        reset_point_name(current_list)
      when :create_card
        list = trello.find(:lists, webhook.list_id)
        reset_point_name(list)
      when :delete_card
        list = trello.find(:lists, webhook.list_id)
        reset_point_name(list)
    end
    render json: {success: true}
  end

  protected

  def reset_point_name(list)
    old_name = list.name
    current_points = points_for(list: list)
    list.name = PointedName.new(list.name).with_points(current_points)
    Rails.logger.info("Updating list.name from '#{old_name}' to '#{list.name}'")
    list.save
  end

  def points_for(list: nil)
    cards = list.cards
    names = cards.map{ |c| c.name }
    PointCalculator.with_names(names).sum
  end

  def build_trello_client(user)
    @trello ||= Trello::Client.new(
      consumer_key: ENV.fetch('TRELLO_KEY'),
      consumer_secret: ENV.fetch('TRELLO_SECRET'),
      oauth_token: user.oauth_token,
      oauth_token_secret: user.oauth_token_secret
    )
  end
end