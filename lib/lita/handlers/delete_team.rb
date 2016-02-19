module Lita
  module Handlers
    class DeleteTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(/(delete|remove) (\S*) team/i, :delete, command: true, help:
      {
        "delete <name> team" => "delete team called <name>",
        "remove <name> team" => "delete team called <name>"
      })

      def delete(response)
        team_name = response.match_data[2]
        if redis.exists(team_name)
          redis.del(team_name)
          response.reply(render_template(:team_deleted, team_name: team_name))
        else
          response.reply(render_template(:team_not_found, team_name: team_name))
        end
      end

      Lita.register_handler(self)
    end
  end
end
