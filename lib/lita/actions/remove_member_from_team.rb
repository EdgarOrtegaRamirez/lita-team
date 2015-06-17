module Lita
  module Actions
    class RemoveMemberFromTeam < Base

      def call
        if team
          if destroy_member
            response.reply render_template(:member_removed_from_team, member: member_name, team: team)
          else
            response.reply t(:member_already_out_of_team, member: member_name, team: team_name)
          end
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      private

      def team_name
        response.match_data[1]
      end

      def member_name
        response.match_data[3] || response.user.mention_name
      end

      def team
        @team ||= Lita::Team.find(team_name)
      end

      def destroy_member
        Lita::Store::Member.destroy(member_name: member_name, team_name: team_name)
      end

    end
  end
end
