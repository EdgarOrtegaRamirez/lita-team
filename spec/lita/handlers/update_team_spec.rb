require "spec_helper"

describe Lita::Handlers::UpdateTeam,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::CreateTeam do
  describe "update team" do
    context "set limit" do
      it "set limit to a given value" do
        send_command "create testing team"
        send_command "testing team set limit 10"
        expect(replies.last).
          to eq("testing team limit set to 10")
      end
    end

    context "set location" do
      it "set location to a given value" do
        send_command "create testing team"
        send_command "testing team set location local place"
        reply = "testing team location set to local place"
        expect(replies.last).to eq(reply)
      end
    end

    context "set icon" do
      it "set icon to a given value" do
        send_command "create testing team"
        send_command "testing team set icon :love:"
        expect(replies.last).
          to eq("testing team icon set to :love:")
      end
    end

    context "team does not exists" do
      it "does not do anything" do
        send_command "testing team set limit 10"
        expect(replies.last).to eq("testing team does not exist")
      end
    end
  end
end
