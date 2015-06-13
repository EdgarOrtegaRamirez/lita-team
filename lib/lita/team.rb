module Lita
  class Team
    attr :name

    def initialize(name)
      @name = name
    end

    class << self
      def find(name)
        data = Lita::Store::Team.find(name)
        data.empty? ? nil : new(data["name"])
      end

      def all
        Lita::Store::Team.all.map do |data|
          new(data["name"])
        end
      end

      def create(name)
        Lita::Store::Team.create(name)
      end

      def destroy(name)
        Lita::Store::Team.destroy(name)
      end
    end

    def members
      @members ||= Lita::Member.all(team_name: name)
    end

  end
end
