require "spec_helper"

describe Lita::Handlers::DeleteTeam,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::CreateTeam do
  describe "delete team" do
    it "deletes a team" do
      send_command "create testing team"
      send_command "delete testing team"
      expect(replies.last).to eq("testing team deleted")
    end

    context "team does not exist" do
      it "does not delete a team" do
        send_command "delete testing team"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
