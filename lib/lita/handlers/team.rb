module Lita
  module Handlers
    class Team
      extend Lita::Handler::ChatRouter

      route(/create (\S*) team/i, :create_team, command: true, help: {
        "create <name> team" => "create team called <name>"
      })
      route(/(delete|remove) (\S*) team/i, :delete_team, command: true, help: {
        "delete <name> team" => "delete team called <name>",
        "remove <name> team" => "delete team called <name>",
      })
      route(/list teams/i, :list_teams, command: true, help: {
        "list teams" => "list all teams"
      })
      route(/(\S*) team (\+1|add me|add (\S*))/i, :add_member_to_team, command: true, help: {
        "<name> team +1" => "add me to team",
        "<name> team add me" => "add me to team",
        "<name> team add <user>" => "add user to team",
      })
      route(/(\S*) team (-1|remove me|remove (\S*))/i, :remove_member_from_team, command: true, help: {
        "<name> team -1" => "remove me from team",
        "<name> team remove me" => "remove me from team",
        "<name> team remove <user>" => "remove <user> from team",
      })
      route(/(\S*) team (list|show)/i, :list_team, command: true, help: {
        "<name> team list" => "list the people in the team",
        "<name> team show" => "list the people in the team",
      })
      route(/(\S*) team (clear|empty)/i, :clear_team, command: true, help: {
        "<name> team clear" => "clear team list",
        "<name> team empty" => "clear team list",
      })

      def create_team(response)
        team_name = response.match_data[1]
        if Lita::Store::Team.create(team_name)
          response.reply t(:team_created, name: team_name)
        else
          response.reply t(:team_already_exists, name: team_name)
        end
      end

      def delete_team(response)
        team_name = response.match_data[2]
        if Lita::Store::Team.destroy(team_name)
          response.reply t(:team_deleted, name: team_name)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      def list_team(response)
        team_name = response.match_data[1]
        if Lita::Store::Team.exists?(team_name)
          members = Lita::Store::Member.all(team_name: team_name)
          response.reply render_template(:list_team, team: team_name, members: members)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      def clear_team(response)
        team_name = response.match_data[1]
        if Lita::Store::Team.exists?(team_name)
          Lita::Store::Member.destroy_all(team_name: team_name)
          response.reply t(:team_cleared, name: team_name)
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      def list_teams(response)
        teams = Lita::Store::Team.all
        response.reply render_template(:list_teams, teams: teams)
      end

      def add_member_to_team(response)
        team_name = response.match_data[1]
        member_name = response.match_data[3] || response.user.name
        if Lita::Store::Team.exists?(team_name)
          count_was = Lita::Store::Member.count(team_name: team_name)
          if Lita::Store::Member.create(member_name: member_name, team_name: team_name)
            response.reply render_template(:member_added_to_team, user: member_name, team: team_name, count: count_was)
          else
            response.reply t(:member_already_in_team, user: member_name, team: team_name)
          end
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end

      def remove_member_from_team(response)
        team_name = response.match_data[1]
        member_name = response.match_data[3] || response.user.name
        if Lita::Store::Team.exists?(team_name)
          if Lita::Store::Member.destroy(member_name: member_name, team_name: team_name)
            remaining = Lita::Store::Member.count(team_name: team_name)
            response.reply render_template(:member_removed_from_team, user: member_name, team: team_name, count: remaining)
          else
            response.reply t(:member_already_out_of_team, user: member_name, team: team_name)
          end
        else
          response.reply t(:team_not_found, name: team_name)
        end
      end
    end

    Lita.register_handler(Team)
  end
end
