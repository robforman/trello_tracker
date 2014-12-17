require "json"

class TrelloWebhookAction
  attr_reader :action, :model

  def initialize(json)
    payload = JSON.parse(json)
    @action = payload.fetch("action")
    @model = payload.fetch("model")
  end

  def change_type
    return :unknown unless ["updateCard", "createCard", "deleteCard"].include?(action["type"])

    case action["type"]
      when "updateCard"
        return :card_list_change if list_before.present? && list_after.present?
        return :card_name_change if was_renamed?
        return :archive_card if was_closed?
      when "createCard"
        return :create_card
      when "deleteCard"
        return :delete_card
    end
  end

  def before_list_id
    ensure_change_type([:card_list_change])
    list_before.fetch("id")
  end

  def after_list_id
    ensure_change_type([:card_list_change])
    list_after.fetch("id")
  end

  def card_id
    ensure_change_type([:card_name_change, :create_card, :delete_card, :archive_card])
    data.fetch("card").fetch("id")
  end

  def list_id
    ensure_change_type([:create_card, :delete_card])
    data.fetch("list").fetch("id")
  end

  private

  def ensure_change_type(acceptable_types)
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
  end

  def data
    action.fetch("data", {})
  end

  def list_before
    data.fetch("listBefore", {})
  end

  def list_after
    data.fetch("listAfter", {})
  end

  def old_data
    data.fetch("old", {})
  end

  def was_renamed?
    old_data.has_key?("name")
  end

  def was_closed?
    old_data.has_key?("closed")
  end
end
