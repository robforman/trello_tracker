require 'spec_helper'
require 'vcr_helper'

describe WebhooksController do
  describe "#create" do
    let(:test_list_id) { "5491423900c84e5e806860b4" }
    let(:create_card_action_json) { '{"action":{"id":"52e42202a9d9de79714c2290","idMemberCreator":"4fc53e097719b45963e8ec35","data":{"board":{"shortLink":"nH91E9Wf","name":"Product Development","id":"50eda21570cb352222003326"},"list":{"name":"Sprint (23)","id":"5491423900c84e5e806860b4"},"card":{"shortLink":"ZQNictBI","idShort":1067,"name":"1 - test card","id":"52e42202a9d9de79714c228f"}},"type":"createCard","date":"2014-01-25T20:43:46.405Z","memberCreator":{"id":"4fc53e097719b45963e8ec35","avatarHash":"380f74c1a9509d0ddd4e5accaf623fbe","fullName":"Rob Forman","initials":"RF","username":"robforman"}},"model":{"id":"50eda21570cb352222003326","name":"Product Development","desc":"","descData":null,"closed":false,"idOrganization":"507d80eaba5c12d37d87f3c4","pinned":true,"url":"https://trello.com/b/nH91E9Wf/product-development","shortUrl":"https://trello.com/b/nH91E9Wf","prefs":{"permissionLevel":"org","voting":"disabled","comments":"members","invitations":"members","selfJoin":false,"cardCovers":false,"cardAging":"regular","calendarFeedEnabled":true,"background":"blue","backgroundColor":"#23719F","backgroundImage":null,"backgroundImageScaled":null,"backgroundTile":false,"backgroundBrightness":"unknown","canBePublic":true,"canBeOrg":true,"canBePrivate":true,"canInvite":true},"labelNames":{"red":"DevOps","orange":"UX","yellow":"Bug","green":"Feature","blue":"Sprint Overflow","purple":"Customers"}}} '}
    let(:user) { User.create!(
        member_id: "4fc53e097719b45963e8ec35", username: "robforman", full_name: "Rob Forman", url: "https://trello.com/robforman",
        oauth_token: ENV.fetch('TEST_OAUTH_TOKEN'), oauth_token_secret: ENV.fetch('TEST_OAUTH_SECRET'),
    )}

    it "detects the create card type and updates the list name", vcr: { cassette_name: "webhooks_controller-create-create_card" } do
      list = user.trello.find(:lists, test_list_id)
      list.name = "Test (0)"
      list.save

      request.env['RAW_POST_DATA'] = create_card_action_json
      expect {
        post :create, user_id: user.id, format: :json
      }.to change{ user.trello.find(:lists, test_list_id).name }
    end
  end
end
