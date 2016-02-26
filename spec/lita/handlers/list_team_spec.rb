require "spec_helper"

describe Lita::Handlers::ListTeam,
         lita_handler: true,
         additional_lita_handlers: [Lita::Handlers::CreateTeam,
                                    Lita::Handlers::AddMemberToTeam,
                                    Lita::Handlers::ConfirmMember,
                                    Lita::Handlers::UpdateTeam] do
  describe "list team" do
    it "lists the members in the team" do
      send_command "create testing team"
      send_command "testing team add james"
      send_command "testing team add john"
      send_command "testing team list"
      expect(replies.last).
        to eq("testing\n:bust_in_silhouette: 2\n1. james\n2. john\n")
    end

    it "list team summary" do
      send_command "create testing team"
      send_command "testing team add melissa"
      send_command "update testing team set limit 10"
      send_command "update testing team set icon :love:"
      send_command "update testing team set location best place"
      send_command "testing team list"
      reply = <<-OUTPUT
:love: testing
:bust_in_silhouette: 1 | :round_pushpin: best place | Max: 10
1. melissa
OUTPUT
      expect(replies.last).to eq(reply)
    end

    it "lists the members with confirmed tag in the team" do
      send_command "create testing team"
      send_command "testing team add james"
      send_command "testing team add john"
      send_command "testing team confirm john"
      send_command "testing team list"
      reply = <<-OUTPUT
testing
:bust_in_silhouette: 2
1. james
2. john :point_up:
OUTPUT
      expect(replies.last).to eq(reply)
    end

    context "team is empty" do
      it "shows a message" do
        send_command "create testing team"
        send_command "testing team list"
        reply = <<-OUTPUT
testing
:bust_in_silhouette: 0
There is no one in the testing team currently
OUTPUT
        expect(replies.last).to eq(reply)
      end
    end

    context "team does not exist" do
      it "shows a message" do
        send_command "testing team list"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
