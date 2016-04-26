require "spec_helper"

describe Lita::Handlers::ClearTeam,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::CreateTeam do
  describe "clear team" do
    it "removes the members of a team" do
      send_command "create testing team"
      send_command "testing team add john"
      send_command "testing team clear"
      expect(replies.last).to eq("testing team cleared")
    end

    it "Doesn't remove the members of a team when the route doesn't match" do
      send_command "create testing team"
      send_command "testing team add john"
      send_command "testing team clear someting"
      expect(replies[0]).to eq("testing team created, add some people to it")
      expect(replies[1]).to be_nil
    end

    context "team does not exist" do
      it "shows a message" do
        send_command "testing team clear"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
