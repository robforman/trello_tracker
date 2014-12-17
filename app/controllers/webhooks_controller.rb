class WebhooksController < ApplicationController
  skip_before_filter :ensure_current_user, only: [:create]
  respond_to :json

  def index
    trello = current_user.trello
    token = trello.find(:token, current_user.oauth_token, webhooks: true)
    @webhooks = token.webhooks
  end

  def create
    user = User.find(params[:user_id])
    return head(:ok) if request.head? || request.get?

    webhook = TrelloWebhookAction.new(request.raw_post)
    Rails.logger.info("Received webhook.change_type of '#{webhook.change_type}'")
    hook_handler = HookHandler.new(user)
    hook_handler.dispatch(webhook)
    render json: {success: true}
  end

  private


  class HookHandler
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def dispatch(webhook)
      send(webhook.change_type, webhook) if respond_to?(webhook.change_type, true)
    end

    private

    def card_list_change(webhook)
      before_list = trello.find(:lists, webhook.before_list_id)
      reset_point_name(before_list)
      after_list = trello.find(:lists, webhook.after_list_id)
      reset_point_name(after_list)
    end

    def card_name_change(webhook)
      card = trello.find(:cards, webhook.card_id)
      current_list = card.list
      reset_point_name(current_list)
    end

    def archive_card(webhook)
      card = trello.find(:cards, webhook.card_id)
      current_list = card.list
      reset_point_name(current_list)
    end

    def create_card(webhook)
      list = trello.find(:lists, webhook.list_id)
      reset_point_name(list)
    end

    def delete_card(webhook)
      raise "delete_card"
      list = trello.find(:lists, webhook.list_id)
      reset_point_name(list)
    end

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

    def trello
      user.trello
    end
  end
end
