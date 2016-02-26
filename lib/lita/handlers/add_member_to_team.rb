module Lita
  module Handlers
    class AddMemberToTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team (\+1|add me|add (\S*))$/i,
        :add,
        command: true,
        help: {
          "<name> team +1" => "add me to team",
          "<name> team add me" => "add me to team",
          "<name> team add <member>" => "add member to team"
        }
      )

      def add(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          if team[:limit] && team[:limit] <= team[:members].count
            return response.reply(
              render_template(:team_cannot_perform_operation,
                              team_name: team_name)
            )
          end
          member_name = (response.match_data[3] ||
                         response.user.mention_name).delete("@")
          if team[:members].key?(member_name.to_sym)
            return response.reply(
              t("member.already_in_team",
                team_name: team_name,
                member_name: member_name)
            )
          end
          member = member_data(member_name)
          count_was = team[:members].count
          team[:members][member_name] = member
          redis.set(team_name, MultiJson.dump(team))
          response.reply(
            render_template(:member_added_to_team,
                            team_name: team_name,
                            member_name: member[:name],
                            count: count_was)
          )
        else
          response.reply(render_template(:team_not_found, team_name: team_name))
        end
      end

      private

      def get_team(team_name)
        data = redis.get(team_name)
        MultiJson.load(data, symbolize_keys: true) if data
      end

      def member_data(member_name)
        if lita_user = Lita::User.fuzzy_find(member_name)
          {
            id: lita_user.id,
            name: lita_user.name,
            mention_name: lita_user.mention_name,
            confirmed: false
          }
        else
          { name: member_name, confirmed: false }
        end
      end

      Lita.register_handler(self)
    end
  end
end
