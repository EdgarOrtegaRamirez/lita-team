require "spec_helper"

describe Lita::Handlers::ConfirmMember,
         lita_handler: true,
         additional_lita_handlers: [Lita::Handlers::CreateTeam,
                                    Lita::Handlers::AddMemberToTeam] do
  describe "confirm member attendance" do
    it "confirm member to the team" do
      send_command "create testing team"
      send_command "testing team add mel"
      send_command "testing team confirm mel"
      expect(replies.last).
        to eq("mel has been confirmed in the testing team")
    end

    context "me" do
      it "confirm current user to the team" do
        send_command "create testing team"
        send_command "testing team add me"
        send_command "testing team confirm me"
        expect(replies.last).
          to eq("#{user.name} has been confirmed in the testing team")
      end
    end

    context "mention" do
      it "uses the lita users database" do
        send_command "create testing team"
        send_command "testing team add @Test"
        send_command "testing team confirm @Test"
        expect(replies.last).
          to eq("Test User has been confirmed in the testing team")
      end

      it "removes @ from non-existing users" do
        send_command "create testing team"
        send_command "testing team add @james"
        send_command "testing team confirm @james"
        expect(replies.last).
          to eq("james has been confirmed in the testing team")
      end
    end

    context "there is a unconfirmed member in the team" do
      it "confirmes the member and displays a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add james"
        send_command "testing team confirm james"
        expect(replies.last).
          to match("1 member has not confirmed yet")
      end
    end

    context "there are two or more unconfirmed members in the team" do
      it "confirmes the member and displays a message" do
        send_command "create testing team"
        send_command "testing team add john"
        send_command "testing team add mel"
        send_command "testing team add james"
        send_command "testing team confirm james"
        expect(replies.last).
          to match("2 members have not confirmed yet")
      end
    end

    context "team does not exist" do
      it "does not confirm the member" do
        send_command "testing team confirm john"
        expect(replies.last).to eq("testing team does not exist")
      end
    end

    context "member not in team" do
      it "does not confirm the member" do
        send_command "create testing team"
        send_command "testing team confirm john"
        expect(replies.last).to eq("john is not on the testing team")
      end
    end
  end
end
