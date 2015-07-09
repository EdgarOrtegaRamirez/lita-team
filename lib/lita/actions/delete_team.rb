module Lita
  module Actions
    class DeleteTeam < Base
      def call
        if Lita::TeamStore.destroy(team_name)
          response.reply t(:team_deleted, name: team_name)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      private

      def team_name
        response.match_data[2]
      end
    end
  end
end
