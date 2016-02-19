require "spec_helper"

describe Lita::Handlers::CreateTeam, lita_handler: true do
  describe "create team" do
    it "creates a new team" do
      send_command "create testing team"
      expect(replies.last).to eq("testing team created, add some people to it")
    end

    context "team already exists" do
      it "does not create a new team" do
        send_command "create testing team"
        send_command "create testing team"
        expect(replies.last).to eq("testing team already exists")
      end
    end
  end
end
