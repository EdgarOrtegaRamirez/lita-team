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
        message = if Lita::Team.create(team_name)
                    t(:team_created, name: team_name)
                  else
                    t(:team_already_exists, name: team_name)
                  end
        response.reply message
      end

      def delete_team(response)
        team_name = response.match_data[2]
        message = if Lita::Team.destroy(team_name)
                    t(:team_deleted, name: team_name)
                  else
                    t(:team_not_found, name: team_name)
                  end
        response.reply message
      end

      def list_team(response)
        team_name = response.match_data[1]
        message = if team = Lita::Team.find(team_name)
                    render_template(:list_team, team: team)
                  else
                    t(:team_not_found, name: team_name)
                  end
        response.reply message
      end

      def clear_team(response)
        team_name = response.match_data[1]
        message = if Lita::Team.find(team_name)
                    Lita::Member.destroy_all(team_name: team_name)
                    t(:team_cleared, name: team_name)
                  else
                    t(:team_not_found, name: team_name)
                  end
        response.reply message
      end

      def list_teams(response)
        teams = Lita::Team.all
        response.reply render_template(:list_teams, teams: teams)
      end

      def add_member_to_team(response)
        team_name = response.match_data[1]
        member_name = response.match_data[3] || response.user.name
        message = if team = Lita::Team.find(team_name)
                    count_was = team.members.count
                    if Lita::Member.create(member_name: member_name, team_name: team_name)
                      render_template(:member_added_to_team, member: member_name, team: team_name, count: count_was)
                    else
                      t(:member_already_in_team, member: member_name, team: team_name)
                    end
                  else
                    t(:team_not_found, name: team_name)
                  end
        response.reply message
      end

      def remove_member_from_team(response)
        team_name = response.match_data[1]
        member_name = response.match_data[3] || response.user.name
        message = if team = Lita::Team.find(team_name)
                    if Lita::Member.destroy(member_name: member_name, team_name: team_name)
                      render_template(:member_removed_from_team, member: member_name, team: team)
                    else
                      t(:member_already_out_of_team, member: member_name, team: team_name)
                    end
                  else
                    t(:team_not_found, name: team_name)
                  end
        response.reply message
      end
    end

    Lita.register_handler(Team)
  end
end
