module Lita
  module Handlers
    class ClearTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team (clear|empty)$/i,
        :clear,
        command: true,
        help: {
          "<name> team clear" => "clear team list",
          "<name> team empty" => "clear team list"
        }
      )

      def clear(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          team[:members] = {}
          redis.set(team[:name], MultiJson.dump(team))
          response.reply(t(:cleared, team_name: team_name))
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
