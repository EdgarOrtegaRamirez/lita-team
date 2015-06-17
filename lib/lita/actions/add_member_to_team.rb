module Lita
  module Actions
    class AddMemberToTeam < Base

      def call
        if team
          count_was = team.members.count
          if create_member
            response.reply render_template(:member_added_to_team, member: member_name, team: team_name, count: count_was)
          else
            response.reply t(:member_already_in_team, member: member_name, team: team_name)
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

      def create_member
        Lita::Store::Member.create(member_name: member_name, team_name: team_name)
      end

    end
  end
end
