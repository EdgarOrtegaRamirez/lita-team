require "spec_helper"

describe Lita::Handlers::ListTeams,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::CreateTeam do
  describe "list teams" do
    it "list all teams" do
      send_command "create testing team"
      send_command "create qa team"
      send_command "list teams"
      reply = <<-OUTPUT
Teams:
qa (0 :bust_in_silhouette:)
testing (0 :bust_in_silhouette:)
OUTPUT
      expect(replies.last).to eq(reply)
    end

    context "without teams" do
      it "shows a message" do
        send_command "list teams"
        expect(replies.last).to eq("No team has been created so far")
      end
    end
  end
end
