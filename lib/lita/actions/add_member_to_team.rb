module Lita
  module Actions
    class AddMemberToTeam < Base
      attr_reader :team_name, :member_name, :team, :lita_user

      def initialize(response)
        super
        @team_name = response.match_data[1]
        @member_name = (response.match_data[3] ||
                          response.user.mention_name).gsub('@', '')
        @team = Lita::Team.find(team_name)
        @lita_user = Lita::User.fuzzy_find(member_name)
      end

      def call
        error = validate
        return response.reply error if error
        count_was = team.members.count
        member = Lita::Member.create(team_name: team_name, attrs: member_attrs)
        response.reply render_template(:member_added_to_team,
                                       member: member,
                                       team: team_name,
                                       count: count_was)
      end

      def validate
        catch :error do
          ensure_team_exists
          ensure_member_not_in_team
        end
      end

      private

      def ensure_team_exists
        return if team
        throw :error, t(:team_not_found, name: team_name)
      end

      def ensure_member_not_in_team
        return unless Lita::MemberStore.exist?(
          team_name: team_name,
          member_name: member_name
        )
        throw :error, t(:member_already_in_team,
                        member: member_name,
                        team: team_name)
      end

      def member_attrs
        if lita_user
          %w(id name mention_name).each_with_object({}) do |m, hsh|
            hsh[m] = lita_user.send(m)
          end
        else
          { 'name' => member_name }
        end
      end
    end
  end
end
