module Lita
  module Actions
    class ClearTeam < Base

      def call
        if team_exists?
          destroy_members
          response.reply t(:team_cleared, name: team_name)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      private

      def team_name
        response.match_data[1]
      end

      def team_exists?
        Lita::Team.find(team_name)
      end

      def destroy_members
        Lita::Store::Member.destroy_all(team_name: team_name)
      end

    end
  end
end
