module Lita
  module Actions
    class CreateTeam < Base

      def call
        if Lita::Store::Team.create(team_name)
          response.reply t(:team_created, name: team_name)
        else
          response.reply t(:team_already_exists, name: team_name)
        end
      end

      private

      def team_name
        response.match_data[1]
      end

    end
  end
end
