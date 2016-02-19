require "spec_helper"

describe Lita::Handlers::RemoveMemberFromTeam,
         lita_handler: true,
         additional_lita_handlers:
          [
            Lita::Handlers::CreateTeam,
            Lita::Handlers::BlockTeam,
            Lita::Handlers::AddMemberToTeam
          ] do
  describe "remove member from team" do
    it "removes a member from the team" do
      send_command "create testing team"
      send_command "testing team add mel"
      send_command "testing team remove mel"
      expect(replies.last).to eq("mel removed from the testing team")
    end

    context "me" do
      it "removes current user from the team" do
        send_command "create testing team"
        send_command "testing team add me"
        send_command "testing team remove me"
        expect(replies.last).to eq("#{user.name} removed from the testing team")
      end
    end

    context "+1" do
      it "removes current user from the team" do
        send_command "create testing team"
        send_command "testing team +1"
        send_command "testing team -1"
        expect(replies.last).to eq("#{user.name} removed from the testing team")
      end
    end

    context "mention" do
      it "uses the lita users database" do
        send_command "create testing team"
        send_command "testing team add @Test"
        send_command "testing team remove @Test"
        expect(replies.last).to eq("Test User removed from the testing team")
      end

      it "removes @ from non-existing users" do
        send_command "create testing team"
        send_command "testing team add @james"
        send_command "testing team remove @james"
        expect(replies.last).to eq("james removed from the testing team")
      end
    end

    context "there are members in the team" do
      before do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
      end
      context "there is a member in the team" do
        it "removes the member and displays a message" do
          send_command "testing team remove james"
          expect(replies.last).
            to eq("james removed from the testing team, 1 other is in")
        end
      end

      context "there are two or more members in the team" do
        it "adds the member and shows a message" do
          send_command "testing team add robert"
          send_command "testing team remove robert"
          expect(replies.last).
            to eq("robert removed from the testing team, 2 others are in")
        end
      end
    end

    context "the member is not in the team" do
      it "does not remove anyone" do
        send_command "create testing team"
        send_command "testing team remove john"
        expect(replies.last).to eq("john is not on the testing team")
      end
    end

    context "team does not exist" do
      it "does not remove the member" do
        send_command "testing team remove john"
        expect(replies.last).to eq("testing team does not exist")
      end
    end

    context "team blocked" do
      it "does not remove the member" do
        send_command "create testing team"
        send_command "testing team add jhon"
        send_command "block testing team"
        send_command "testing team remove jhon"
        reply =
          "testing team is blocked. You cannot perform this operation"
        expect(replies.last).to eq(reply)
      end
    end
  end
end
