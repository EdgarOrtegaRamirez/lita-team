module Lita
  module Handlers
    class Team
      extend Lita::Handler::ChatRouter

      route(/create (\S*) team/i, command: true, help: {
              'create <name> team' => 'create team called <name>'
            }) do |response|
              Lita::Actions::CreateTeam.new(response).call
            end

      route(/(delete|remove) (\S*) team/i, command: true, help: {
              'delete <name> team' => 'delete team called <name>',
              'remove <name> team' => 'delete team called <name>'
            }) do |response|
              Lita::Actions::DeleteTeam.new(response).call
            end

      route(/list teams/i, command: true, help: {
              'list teams' => 'list all teams'
            }) do |response|
              Lita::Actions::ListTeams.new(response).call
            end

      route(/(\S*) team (\+1|add me|add (\S*))/i, command: true, help: {
              '<name> team +1' => 'add me to team',
              '<name> team add me' => 'add me to team',
              '<name> team add <user>' => 'add user to team'
            }) do |response|
              Lita::Actions::AddMemberToTeam.new(response).call
            end

      route(/(\S*) team (-1|remove me|remove (\S*))/i, command: true, help: {
              '<name> team -1' => 'remove me from team',
              '<name> team remove me' => 'remove me from team',
              '<name> team remove <user>' => 'remove <user> from team'
            }) do |response|
              Lita::Actions::RemoveMemberFromTeam.new(response).call
            end

      route(/(\S*) team (list|show)/i, command: true, help: {
              '<name> team list' => 'list the people in the team',
              '<name> team show' => 'list the people in the team'
            }) do |response|
              Lita::Actions::ListTeam.new(response).call
            end

      route(/(\S*) team (clear|empty)/i, command: true, help: {
              '<name> team clear' => 'clear team list',
              '<name> team empty' => 'clear team list'
            }) do |response|
              Lita::Actions::ClearTeam.new(response).call
            end
    end

    Lita.register_handler(Team)
  end
end
