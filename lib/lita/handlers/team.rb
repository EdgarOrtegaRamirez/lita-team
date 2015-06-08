module Lita
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
      route(/(\S*)? team (list|show)/i, :list_team, command: true, help: {
        "<name> team (list|show)" => "list the people in the team"
      })
      route(/(\S*)? team (clear|empty)/i, :clear_team, command: true, help: {
        "<name> team (clear|empty)" => "clear team list"
      })

      def create_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.hsetnx(team.key, :name, team.name)
          response.reply t(:team_created, name: team.display_name)
        else
          response.reply t(:team_already_exists, name: team.display_name)
        end
      end

      def delete_team(response)
        team = Lita::Team.new(response.match_data[2])
        if redis.exists(team.key)
          redis.del team.key
          response.reply t(:team_deleted, name: team.display_name)
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end

      def list_teams(response)
        keys = redis.keys "team*"
        teams = keys.map do |key|
          team_data = redis.hgetall(key)
          Lita::Team.new(team_data["name"])
        end
        response.reply render_template(:list_teams, teams: teams)
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
          if redis.sadd(team.members_key, user)
            message = t(:member_added_to_team, user: user, team: team.display_name)
            message << t(:members_in_team, count: count_was) if count_was > 0
            response.reply message
          else
            response.reply t(:member_already_in_team, user: user, team: team.display_name)
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
            message = t(:member_removed_from_team, user: user, team: team.display_name)
            message << t(:members_in_team, count: remaining) if remaining > 0
            response.reply message
          else
            response.reply t(:member_already_out_of_team, user: user, team: team.display_name)
          end
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end

      def list_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.exists(team.key)
          members = redis.smembers(team.members_key)
          response.reply render_template(:list_team, team: team.display_name, members: members)
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end

      def clear_team(response)
        team = Lita::Team.new(response.match_data[1])
        if redis.exists(team.key)
          redis.del(team.members_key)
          response.reply t(:team_cleared, name: team.display_name)
        else
          response.reply t(:team_not_found, name: team.display_name)
        end
      end
    end

    Lita.register_handler(Team)
  end
end
