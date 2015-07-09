module Lita
  class Member
    attr_reader :id, :name, :metion_name

    def initialize(attrs = {})
      @id = attrs['id']
      @name = attrs['name']
      @mention_name = attrs['mention_name']
    end

    def self.all(team_name:)
      Lita::MemberStore.all(team_name: team_name).map { |data| new(data) }
    end

    def self.create(team_name:, attrs:)
      Lita::MemberStore.create(
        team_name: team_name,
        attrs: attrs
      )
      new attrs
    end
  end
end
