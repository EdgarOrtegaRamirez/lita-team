module Lita
  module Handlers
    class RemoveMemberFromTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team (-1|remove me|remove (\S*))$/i,
        :remove,
        command: true,
        help:
        {
          "<name> team -1" => "remove me from team",
          "<name> team remove me" => "remove me from team",
          "<name> team remove <member>" => "remove member from team"
        }
      )

      def remove(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          if team[:limit] && team[:limit] <= team[:members].count
            return response.reply(
              render_template(:team_cannot_perform_operation,
                              team_name: team_name)
            )
          else
            member_name = (response.match_data[3] ||
                           response.user.mention_name).delete("@")
            if team[:members].key?(member_name.to_sym)
              member = team[:members].delete(member_name.to_sym)
              count = team[:members].count
              redis.set(team_name, MultiJson.dump(team))
              response.reply(
                render_template(:member_removed_from_team,
                                team_name: team_name,
                                member_name: member[:name],
                                count: count)
              )
            else
              response.reply(
                t("member.not_in_team",
                  team_name: team_name,
                  member_name: member_name)
              )
            end
          end
        else
          response.reply(render_template(:team_not_found, team_name: team_name))
        end
      end

      private

      def get_team(team_name)
        data = redis.get(team_name)
        MultiJson.load(data, symbolize_keys: true) if data
      end

      Lita.register_handler(self)
    end
  end
end
