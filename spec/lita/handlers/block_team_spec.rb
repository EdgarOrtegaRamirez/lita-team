require "spec_helper"

describe Lita::Handlers::BlockTeam,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::CreateTeam do
  describe "block team" do
    it "blocks a team" do
      send_command "create testing team"
      send_command "block testing team"
      expect(replies.last).to eq("testing team blocked")
    end

    context "team already exists" do
      it "does not block any team" do
        send_command "block testing team"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end

  describe "unblock team" do
    it "unblocks a team" do
      send_command "create testing team"
      send_command "block testing team"
      send_command "unblock testing team"
      expect(replies.last).to eq("testing team unblocked")
    end
  end
end
