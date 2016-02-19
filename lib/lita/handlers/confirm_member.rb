module Lita
  module Handlers
    class ConfirmMember < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team confirm (me|(\S*))$/i,
        :confirm,
        command: true,
        help: {
          "<name> team confirm me" => "confirm attendance",
          "<name> team remove <member>" => "confirm member attendance"
        }
      )

      def confirm(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          member_name = (response.match_data[3] ||
                         response.user.mention_name).delete("@")
          if member = team[:members][member_name.to_sym]
            member[:confirmed] = true
            unconfirmed = team[:members].count { |_k, v| !v[:confirmed] }
            redis.set(team_name, MultiJson.dump(team))
            response.reply(
              render_template(:member_confirmed,
                              team_name: team_name,
                              member_name: member[:name],
                              count: unconfirmed)
            )
          else
            response.reply(
              t("member.not_in_team",
                team_name: team_name,
                member_name: member_name)
            )
          end
        else
          response.reply(
            render_template(:team_not_found, team_name: team_name)
          )
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
