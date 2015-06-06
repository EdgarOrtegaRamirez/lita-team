module Lita
  Team = Struct.new(:name) do
    def key
      "team:#{name}"
    end

    def members_key
      "#{key}:members"
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
      route(/(\S*)? team add (\S*)/i, :add_member_to_team, command: true, help: {
        "<name> team add <user>" => "add me or <user> to team"
      })
      route(/(\S*)? team remove (\S*)/i, :remove_member_from_team, command: true, help: {
        "<name> team remove <user>" => "remove me or <user> from team"
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

      def add_member_to_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.exists(team.key)
          user = if "me" == response.match_data[2]
                   response.user.name
                 else
                   response.match_data[2]
                 end
          count_was = redis.scard(team.members_key)
          extra_message = if 0 == count_was
                            ""
                          elsif 1 == count_was
                            ", 1 other is in"
                          else
                            ", #{count_was} others are in"
                          end
          if redis.sadd(team.members_key, user)
            response.reply "#{user} added to the #{team.display_name}#{extra_message}"
          else
            response.reply "#{user} already in the #{team.display_name}"
          end
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end

      def remove_member_from_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.exists(team.key)
          user = if "me" == response.match_data[2]
                   response.user.name
                 else
                   response.match_data[2]
                 end
          if redis.srem(team.members_key, user)
            remaining = redis.scard(team.members_key)
            if 0 == remaining
              response.reply "#{user} removed from the #{team.display_name}"
            else
              response.reply "#{user} removed from the #{team.display_name}, #{remaining} remaining"
            end
          else
            response.reply "#{user} already out of the #{team.display_name}"
          end
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end
    end

    Lita.register_handler(Team)
  end
end
