module Lita
  class Team
    attr_reader :name

    def initialize(attrs)
      @name = attrs['name']
    end

    def self.find(name)
      return nil unless Lita::TeamStore.exists?(name)
      data = Lita::TeamStore.find(name)
      new(data)
    end

    def self.all
      Lita::TeamStore.all.map { |data| new(data) }
    end

    def members
      @members ||= Lita::Member.all(team_name: name)
    end
  end
end
