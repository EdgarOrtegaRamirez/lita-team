module Lita
  module Store
    module Team
      extend self

      def redis
        @redis ||= Redis::Namespace.new("handlers:team:team", redis: Lita.redis)
      end

      def exists?(team_name)
        redis.exists(team_name)
      end

      def create(team_name)
        redis.hsetnx(team_name, :name, team_name)
      end

      def destroy(team_name)
        redis.del(team_name) != 0
      end

      def all
        redis.keys.map do |key|
          data = redis.hgetall(key)
          model.new(data["name"])
        end
      end

      private

      def model
        Lita::Team
      end

    end
  end
end
