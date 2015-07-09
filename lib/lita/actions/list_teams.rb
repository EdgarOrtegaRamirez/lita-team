module Lita
  module Actions
    class ListTeams < Base
      def call
        response.reply render_template(:list_teams, teams: Lita::Team.all)
      end
    end
  end
end
