require_relative "../../lib/trello_webhook_action"

describe TrelloWebhookAction do
  let(:card_list_change_action_json) { '{"action":{"id":"52e0055961ed8113521249bb","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"listAfter":{"name":"Working","id":"50eda21570cb352222003328"},"listBefore":{"name":"Sprint ","id":"50eda27e70cb35222200333e"},"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"card":{"shortLink":"dtZDDhcT","idShort":1052,"name":"5 - Backfill Email Patterns","id":"52deb4919a4ce83458b40fb8","idList":"50eda21570cb352222003328"},"old":{"idList":"50eda27e70cb35222200333e"}},"type":"updateCard","date":"2014-01-22T17:52:25.564Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#205C7E","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:card_name_change_action_json) { '{"action":{"id":"52e0072d5c541e4c2046f3ab","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"card":{"shortLink":"dtZDDhcT","idShort":1052,"id":"52deb4919a4ce83458b40fb8","name":"8 - Backfill Email Patterns"},"old":{"name":"5 - Backfill Email Patterns"}},"type":"updateCard","date":"2014-01-22T18:00:13.009Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#205C7E","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:create_card_action_json)      { '{"action":{"id":"52e42202a9d9de79714c2290","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"list":{"name":"Sprint (23)","id":"50eda27e70cb35222200333e"},"card":{"shortLink":"ZQNictBI","idShort":1067,"name":"1 - test card","id":"52e42202a9d9de79714c228f"}},"type":"createCard","date":"2014-01-25T20:43:46.405Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#23719F","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"red":"DevOps","orange":"UX","yellow":"Bug","green":"Feature","blue":"Sprint Overflow","purple":"Customers"}}} '}
  let(:delete_card_action_json)      { '{"action":{"id":"52e42a86ca72d2c64f6a3f85","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"list":{"name":"Sprint (33)","id":"50eda27e70cb35222200333e"},"card":{"idShort":1070,"id":"52e42a7d5836cbf247244f48"}},"type":"deleteCard","date":"2014-01-25T21:20:06.474Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#23719F","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:update_card_archive_json)     { '{"action":{"id":"52e42789394e19ca5ae36d61","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"card":{"shortLink":"ZQNictBI","idShort":1067,"name":"1 - test card","id":"52e42202a9d9de79714c228f","closed":true},"old":{"closed":false}},"type":"updateCard","date":"2014-01-25T21:07:21.309Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#23719F","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"yellow":"Bug","red":"DevOps","purple":"Customers","orange":"UX","green":"Feature","blue":"Sprint Overflow"}}}' }
  let(:empty_action)                 { '{ "action": {}, "model": {} }' }

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

    it "recognizes a create card action" do
      expect(TrelloWebhookAction.new(create_card_action_json).change_type).to eq(:create_card)
    end

    it "recognizes a delete card action" do
      expect(TrelloWebhookAction.new(delete_card_action_json).change_type).to eq(:delete_card)
    end

    it "recognizes an archive card action" do
      expect(TrelloWebhookAction.new(update_card_archive_json).change_type).to eq(:archive_card)
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

  context "change_type :create_card" do
    let(:action) { create_card_action_json }

    describe ".list_id" do
      it "knows the list id where the card was created" do
        expect(TrelloWebhookAction.new(action).list_id).to eq("50eda27e70cb35222200333e")
      end
    end

    describe ".card_id" do
      it "knows the card id of the card created" do
        expect(TrelloWebhookAction.new(action).card_id).to eq("52e42202a9d9de79714c228f")
      end
    end
  end

  context "change_type :delete_card" do
    let(:action) { delete_card_action_json }

    describe ".list_id" do
      it "knows the list id where the card was deleted" do
        expect(TrelloWebhookAction.new(action).list_id).to eq("50eda27e70cb35222200333e")
      end
    end

    describe ".card_id" do
      it "knows the card id of the card deleted" do
        expect(TrelloWebhookAction.new(action).card_id).to eq("52e42a7d5836cbf247244f48")
      end
    end
  end

  context "change_type :archive_card" do
    let(:action) { update_card_archive_json }

    describe ".card_id" do
      it "knows the card id of the card archived" do
        expect(TrelloWebhookAction.new(action).card_id).to eq("52e42202a9d9de79714c228f")
      end
    end
  end
end