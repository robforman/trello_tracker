require "json"

class TrelloWebhookAction
  attr_reader :action, :model

  def initialize(json)
    payload = JSON.parse(json)
    @action = payload.fetch("action")
    @model = payload.fetch("model")
  end

  def change_type
    @change_type ||= begin
      if action.fetch("type", "") == "updateCard"
        if action.fetch("data", {}).has_key?("listBefore") && action.fetch("data", {}).has_key?("listAfter")
          return :card_list_change
        end

        if action.fetch("data", {}).fetch("old", {}).has_key?("name")
          return :card_name_change
        end
      end

      :unknown
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
    acceptable_types = [:card_name_change]
    raise StandardError.new("Mismatch change_type: #{change_type}") unless acceptable_types.include?(change_type)
    action.fetch("data").fetch("card").fetch("id")
  end
end
