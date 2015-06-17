module Lita
  module Store
    module Team
      extend self

      def redis
        @redis ||= Redis::Namespace.new("handlers:team:team", redis: Lita.redis)
      end

      def find(team_name)
        redis.hgetall(team_name)
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
        redis.keys.sort.map do |key|
          redis.hgetall(key)
        end
      end

    end
  end
end
