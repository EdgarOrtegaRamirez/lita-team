require "spec_helper"

describe Lita::Handlers::AddMemberToTeam,
         lita_handler: true,
         additional_lita_handlers: [Lita::Handlers::CreateTeam,
                                    Lita::Handlers::BlockTeam] do
  describe "add member to team" do
    it "adds a member to the team" do
      send_command "create testing team"
      send_command "testing team add mel"
      expect(replies.last).to eq("mel added to the testing team")
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

    context "mention" do
      it "uses the lita users database" do
        send_command "create testing team"
        send_command "testing team add @Test"
        expect(replies.last).to eq("Test User added to the testing team")
      end

      it "removes @ from non-existing users" do
        send_command "create testing team"
        send_command "testing team add @james"
        expect(replies.last).to eq("james added to the testing team")
      end
    end

    context "there is a member in the team" do
      it "adds the member and shows a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        expect(replies.last).
          to eq("james added to the testing team, 1 other is in")
      end
    end

    context "there are two or more members in the team" do
      it "adds the member and shows a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        send_command "testing team add robert"
        expect(replies.last).
          to eq("robert added to the testing team, 2 others are in")
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

    context "team blocked" do
      it "does not add the member" do
        send_command "create testing team"
        send_command "block testing team"
        send_command "testing team add john"
        reply =
          "testing team is blocked. You cannot perform this operation"
        expect(replies.last).to eq(reply)
      end
    end
  end
end
