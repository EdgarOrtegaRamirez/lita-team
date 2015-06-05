module Lita
  Team = Struct.new(:name)

  module Handlers
    class Team < Handler

      route(/create (\S*) team/i, :create, command: true, help: {
        "create <name> team" => "create team called <name>"
      })

      def create(response)
        require 'pry-byebug'; binding.pry
        team = Team.new(response.match_data[1])
        teams = get_teams
        teams << team
        team
      end

      def get_teams
        redis.set("teams", []) if redis.get("teams").nil?
        MultiJson.load(redis.get("teams")).map do |team|
          Team
        end
      end

      def set_teams(teams)
        data = teams.map(&:to_h)
        redis.set("teams", data)
      end

      # route(/^echo\s+(.+)/, :echo, command: true, help: {
      #   "echo TEXT" => "Replies back with TEXT."
      # })
      # def echo(response)
      #   response.reply(response.matches)
      # end
    end

    Lita.register_handler(Team)

  end
end
