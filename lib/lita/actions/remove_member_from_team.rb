module Lita
  module Actions
    class RemoveMemberFromTeam < Base
      attr_reader :team_name, :member_name, :team, :lita_user

      def initialize(response)
        super
        @team_name = response.match_data[1]
        @member_name = (response.match_data[3] ||
                        response.user.mention_name).gsub('@', '')
        @team = Lita::Team.find(team_name)
        @lita_user = Lita::User.fuzzy_find(member_name)
      end

      def call
        error = validate
        return response.reply error if error
        destroy_member
        response.reply render_template(:member_removed_from_team,
                                       member: mention_name,
                                       team: team)
      end

      def validate
        catch :error do
          ensure_team_exists
          ensure_member_in_team
        end
      end

      private

      def ensure_team_exists
        return if team
        throw :error, t(:team_not_found, name: team_name)
      end

      def ensure_member_in_team
        return if Lita::MemberStore.exist?(
          team_name: team_name,
          member_name: mention_name
        )
        throw :error, t(:member_already_out_of_team,
                        member: mention_name,
                        team: team_name)
      end

      def mention_name
        lita_user ? lita_user.mention_name : member_name
      end

      def destroy_member
        Lita::MemberStore.destroy(
          member_name: mention_name,
          team_name: team_name
        )
      end
    end
  end
end
