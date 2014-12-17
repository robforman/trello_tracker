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
        return :card_list_change if has_listBefore? && has_listAfter?
        return :card_name_change if was_renamed?
        return :archive_card if was_closed?
      when "createCard"
        return :create_card
      when "deleteCard"
        return :delete_card
    end
  end

  def before_list_id
    acceptable_types = [:card_list_change]
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
    action.fetch("data").fetch("listBefore").fetch("id")
  end

  def after_list_id
    acceptable_types = [:card_list_change]
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
    action.fetch("data").fetch("listAfter").fetch("id")
  end

  def card_id
    acceptable_types = [:card_name_change, :create_card, :delete_card, :archive_card]
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
    action.fetch("data").fetch("card").fetch("id")
  end

  def list_id
    acceptable_types = [:create_card, :delete_card]
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
    action.fetch("data").fetch("list").fetch("id")
  end

  private

  def card_data
    action.fetch("data", {})
  end

  def old_data
    card_data.fetch("old", {})
  end

  def has_listBefore?
    card_data.has_key?("listBefore")
  end

  def has_listAfter?
    card_data.has_key?("listAfter")
  end

  def was_renamed?
    old_data.has_key?("name")
  end

  def was_closed?
    old_data.has_key?("closed")
  end
end
