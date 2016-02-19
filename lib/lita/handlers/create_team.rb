module Lita
  module Handlers
    class CreateTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /create (\S*) team/i,
        :create,
        command: true,
        help: {
          "create <name> team" => "create team called <name>"
        }
      )

      def create(response)
        team_name = response.match_data[1]
        if redis.exists(team_name)
          response.reply(
            render_template(:team_already_exists, team_name: team_name)
          )
        else
          data = {
            name: team_name,
            limit: nil,
            location: nil,
            icon: nil,
            members: {}
          }
          redis.set(team_name, MultiJson.dump(data))
          response.reply(render_template(:team_created, team_name: team_name))
        end
      end

      Lita.register_handler(self)
    end
  end
end
