module Lita
  Team = Struct.new(:name) do
    def key
      "team:#{name}"
    end

    def members_key
      "members:#{name}"
    end

    def display_name
      "#{name} team"
    end
  end
end
