module Lita
  Team = Struct.new(:name) do
    def key
      "team:#{name}"
    end

    def display_name
      "#{name} team"
    end
  end

  module Handlers
    class Team < Handler

      route(/create (\S*) team/i, :create_team, command: true, help: {
        "create <name> team" => "create team called <name>"
      })
      route(/(delete|remove) (\S*) team/i, :delete_team, command: true, help: {
        "(delete|remove) <name> team" => "delete team called <name>"
      })
      route(/list teams/i, :list_teams, command: true, help: {
        "list teams" => "list all teams"
      })

      def create_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.exists(team.key)
          response.reply "#{team.display_name} already exists"
        else
          redis.hset(team.key, :name, team.name)
          response.reply "#{team.display_name} created, add some people to it"
        end
      end

      def delete_team(response)
        team = Lita::Team.new(response.match_data[2])
        if redis.exists(team.key)
          redis.del team.key
          response.reply "#{team.display_name} deleted"
        else
          response.reply "#{team.display_name} does not exist"
        end
      end

      def list_teams(response)
        keys = redis.keys "team*"
        if keys.empty?
          response.reply "No team has been created so far"
        else
          message = "Teams:\n"
          keys.each do |key|
            team = redis.hgetall(key)
            message << "#{team["name"]}\n"
          end
          response.reply(message)
        end
      end
    end

    Lita.register_handler(Team)
  end
end
