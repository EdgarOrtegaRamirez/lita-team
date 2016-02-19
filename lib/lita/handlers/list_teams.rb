module Lita
  module Handlers
    class ListTeams < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /list teams/i,
        :list,
        command: true,
        help: {
          "list teams" => "list all teams"
        }
      )

      def list(response)
        keys = redis.keys
        if keys.empty?
          response.reply t(:no_teams_has_been_created)
        else
          teams = redis.mget(redis.keys("*")).map(&parse)
          response.reply render_template(:list_teams, teams: teams)
        end
      end

      private

      def parse
        -> (team) { MultiJson.load(team, symbolize_keys: true) }
      end

      Lita.register_handler(self)
    end
  end
end
