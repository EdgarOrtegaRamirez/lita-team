module Lita
  class Member
    attr :name

    def initialize(name)
      @name = name
    end

    class << self
      def all(team_name:)
        Lita::Store::Member.all(team_name: team_name).map do |data|
          new(data["name"])
        end
      end

      def destroy(member_name:, team_name:)
        Lita::Store::Member.destroy(member_name: member_name, team_name: team_name)
      end

      def destroy_all(team_name:)
        Lita::Store::Member.destroy_all(team_name: team_name)
      end

      def create(member_name:, team_name:)
        Lita::Store::Member.create(member_name: member_name, team_name: team_name)
      end
    end
  end
end
