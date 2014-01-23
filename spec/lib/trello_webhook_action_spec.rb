require_relative "../../lib/trello_webhook_action"

describe TrelloWebhookAction do
  let(:card_list_change_action_json) { '{"action":{"id":"52e0055961ed8113521249bb","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"listAfter":{"name":"Working","id":"50eda21570cb352222003328"},"listBefore":{"name":"Sprint ","id":"50eda27e70cb35222200333e"},"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"card":{"shortLink":"dtZDDhcT","idShort":1052,"name":"5 - Backfill Email Patterns","id":"52deb4919a4ce83458b40fb8","idList":"50eda21570cb352222003328"},"old":{"idList":"50eda27e70cb35222200333e"}},"type":"updateCard","date":"2014-01-22T17:52:25.564Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#205C7E","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:card_name_change_action_json) { '{"action":{"id":"52e0072d5c541e4c2046f3ab","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"card":{"shortLink":"dtZDDhcT","idShort":1052,"id":"52deb4919a4ce83458b40fb8","name":"8 - Backfill Email Patterns"},"old":{"name":"5 - Backfill Email Patterns"}},"type":"updateCard","date":"2014-01-22T18:00:13.009Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#205C7E","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:empty_action) { '{ "action": {}, "model": {} }' }

  describe ".new" do
    it "requires json" do
      expect{ TrelloWebhookAction.new('') }.to raise_error(JSON::ParserError)
    end

    it "parses json" do
      expect{ TrelloWebhookAction.new(card_list_change_action_json).not_to raise_error }
    end
  end

  describe ".change_type" do
    it "recognizes a list change" do
      expect(TrelloWebhookAction.new(card_list_change_action_json).change_type).to eq(:card_list_change)
    end

    it "recognizes a card name change" do
      expect(TrelloWebhookAction.new(card_name_change_action_json).change_type).to eq(:card_name_change)
    end

    it "lets you know if it can't figure it out" do
      expect(TrelloWebhookAction.new(empty_action).change_type).to eq(:unknown)
    end
  end

  context "change_type :card_list_change" do
    let(:action) { card_list_change_action_json }

    describe ".before_list_id" do
      it "knows the list a card is on after the change" do
        expect(TrelloWebhookAction.new(action).before_list_id).to eq("50eda27e70cb35222200333e")
      end
    end

    describe ".after_list_id" do
      it "knows the list a card is on before the change" do
        expect(TrelloWebhookAction.new(action).after_list_id).to eq("50eda21570cb352222003328")
      end
    end
  end

  context "change_type :card_name_change" do
    let(:action) { card_name_change_action_json }

    describe ".card_id" do
      it "knows the card id after changing its name (and thus point value)" do
        expect(TrelloWebhookAction.new(action).card_id).to eq("52deb4919a4ce83458b40fb8")
      end
    end
  end
end