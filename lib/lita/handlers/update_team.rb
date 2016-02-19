module Lita
  module Handlers
    class UpdateTeam < Handler
      namespace :team
      template_root File.expand_path("../../../../templates", __FILE__)

      route(
        /(\S*) team set (limit|location|icon) (.+)/i,
        :update,
        command: true,
        help: {
          "<name> team set limit <value>" => "update team members limit",
          "<name> team set location <value>" => "update team location",
          "<name> team set icon <value>" => "update team icon"
        }
      )

      ATTRIBUTES_MAPPING = {
        limit: :to_i,
        location: :to_s,
        icon: :to_s
      }.freeze

      def update(response)
        team_name = response.match_data[1]
        if team = get_team(team_name)
          attribute = response.match_data[2].to_sym
          value = parse_attribute_value(attribute, response.match_data[3])
          team[attribute] = value
          save_team(team)
          response.reply(
            render_template(:team_updated,
                            team_name: team_name,
                            attribute: attribute,
                            value: value
                           )
          )
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

      def save_team(team)
        redis.set(team[:name], MultiJson.dump(team))
      end

      def parse_attribute_value(attribute, raw_value)
        raw_value.send(ATTRIBUTES_MAPPING[attribute])
      end

      Lita.register_handler(self)
    end
  end
end
