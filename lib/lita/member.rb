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
    end
  end
end
