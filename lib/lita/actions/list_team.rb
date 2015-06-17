module Lita
  module Actions
    class ListTeam < Base

      def call
        if team
          response.reply render_template(:list_team, team: team)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      private

      def team_name
        response.match_data[1]
      end

      def team
        @team ||= Lita::Team.find(team_name)
      end

    end
  end
end
