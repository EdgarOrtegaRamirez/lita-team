module Lita
  module Handlers
    class ListTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team (list|show)/i,
        :list,
        command: true,
        help: {
          "<name> team list" => "list the people in the team",
          "<name> team show" => "list the people in the team"
        }
      )

      def list(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          response.reply(render_template(:list_team, team: team))
        else
          response.reply(render_template(:team_not_found, team_name: team_name))
        end
      end

      private

      def get_team(team_name)
        data = redis.get(team_name)
        MultiJson.load(data, symbolize_keys: true) if data
      end

      Lita.register_handler(self)
    end
  end
end
