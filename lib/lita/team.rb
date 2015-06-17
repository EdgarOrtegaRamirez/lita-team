module Lita
  class Team
    attr :name

    def initialize(name)
      @name = name
    end

    class << self
      def find(name)
        return nil unless Lita::Store::Team.exists?(name)
        new(Lita::Store::Team.find(name)["name"])
      end

      def all
        Lita::Store::Team.all.map do |data|
          new(data["name"])
        end
      end
    end

    def members
      @members ||= Lita::Member.all(team_name: name)
    end

  end
end
