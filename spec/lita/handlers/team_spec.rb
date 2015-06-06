require "spec_helper"

describe Lita::Handlers::Team, lita_handler: true do
  describe "routes" do
    it { is_expected.to route_command("create testing team").to(:create_team) }
    it { is_expected.to route_command("delete testing team").to(:delete_team) }
    it { is_expected.to route_command("list teams").to(:list_teams) }
  end

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

  describe "list teams" do
    it "list all teams" do
      send_command "create testing team"
      send_command "list teams"
      expect(replies.last).to eq("Teams:\ntesting\n")
    end

    context "without teams" do
      it "shows a message" do
        send_command "list teams"
        expect(replies.last).to eq("No team has been created so far")
      end
    end
  end
end
