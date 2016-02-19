module Lita
  module Handlers
    class BlockTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(block|unblock) (\S*) team/i,
        :toggle_block,
        command: true,
        help: {
          "block <name> team" => "block team called <name>",
          "unblock <name> team" => "unblock team called <name>"
        }
      )

      def toggle_block(response)
        team_name = response.match_data[2]
        action = response.match_data[1]
        if team = get_team(team_name)
          team[:limit] = action == "block" ? team[:members].size : nil
          redis.set(team[:name], MultiJson.dump(team))
          response.reply(
            render_template("team_#{action}ed".to_sym, team_name: team_name)
          )
        else
          response.reply(
            render_template(:team_not_found, team_name: team_name)
          )
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
