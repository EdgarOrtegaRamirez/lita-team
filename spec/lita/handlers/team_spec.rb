require "spec_helper"

describe Lita::Handlers::Team, lita_handler: true do
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
      send_command "create qa team"
      send_command "list teams"
      expect(replies.last).to eq("Teams:\nqa (0 members)\ntesting (0 members)\n")
    end

    context "without teams" do
      it "shows a message" do
        send_command "list teams"
        expect(replies.last).to eq("No team has been created so far")
      end
    end
  end

  describe "add member to team" do
    it "adds a member to the team" do
      send_command "create testing team"
      send_command "testing team add john"
      expect(replies.last).to eq("john added to the testing team")
    end

    context "me" do
      it "adds current user to the team" do
        send_command "create testing team"
        send_command "testing team add me"
        expect(replies.last).to eq("#{user.name} added to the testing team")
      end
    end

    context "+1" do
      it "adds current user to the team" do
        send_command "create testing team"
        send_command "testing team +1"
        expect(replies.last).to eq("#{user.name} added to the testing team")
      end
    end

    context "there is a member in the team" do
      it "adds the member and shows a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        expect(replies.last).to eq("james added to the testing team, 1 other is in")
      end
    end

    context "there are two or more members in the team" do
      it "adds the member and shows a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        send_command "testing team add robert"
        expect(replies.last).to eq("robert added to the testing team, 2 others are in")
      end
    end

    context "the member is already in the team" do
      it "does not add the member to the team" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add john"
        expect(replies.last).to eq("john already in the testing team")
      end
    end

    context "team does not exist" do
      it "does not add the member" do
        send_command "testing team add john"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end

  describe "remove member from team" do
    it "removes a member from the team" do
      send_command "create testing team"
      send_command "testing team add john"
      send_command "testing team remove john"
      expect(replies.last).to eq("john removed from the testing team")
    end

    context "me" do
      it "removes current user from the team" do
        send_command "create testing team"
        send_command "testing team add me"
        send_command "testing team remove me"
        expect(replies.last).to eq("#{user.name} removed from the testing team")
      end
    end

    context "-1" do
      it "removes current user from the team" do
        send_command "create testing team"
        send_command "testing team +1"
        send_command "testing team -1"
        expect(replies.last).to eq("#{user.name} removed from the testing team")
      end
    end

    context "there are two or more members in the team" do
      it "adds the member and shows a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        send_command "testing team remove john"
        expect(replies.last).to eq("john removed from the testing team, 1 other is in")
      end
    end

    context "the member is not in the team" do
      it "does not removes the member from the team" do
        send_command "create testing team"
        send_command "testing team remove john"
        expect(replies.last).to eq("john already out of the testing team")
      end
    end

    context "team does not exist" do
      it "does not add the member" do
        send_command "testing team remove john"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end

  describe "list team" do
    it "lists the members in the team" do
      send_command "create testing team"
      send_command "testing team add james"
      send_command "testing team add john"
      send_command "testing team list"
      expect(replies.last).to eq("testing (2 members):\n1. james\n2. john\n")
    end

    context "team is empty" do
      it "shows a message" do
        send_command "create testing team"
        send_command "testing team list"
        expect(replies.last).to eq("There is no one in the testing team currently")
      end
    end

    context "team does not exist" do
      it "shows a message" do
        send_command "testing team list"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end

  describe "clear team" do
    it "removes the members of a team" do
      send_command "create testing team"
      send_command "testing team add john"
      send_command "testing team clear"
      expect(replies.last).to eq("testing team cleared")
      send_command "testing team list"
      expect(replies.last).to eq("There is no one in the testing team currently")
    end

    context "team does not exist" do
      it "shows a message" do
        send_command "testing team clear"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
