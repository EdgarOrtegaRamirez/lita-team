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

    context "team does not exist" do
      it "shows a message" do
        send_command "testing team clear"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
