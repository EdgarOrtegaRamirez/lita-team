module Lita
  module Store
    module Member
      extend self

      def redis
        @redis ||= Redis::Namespace.new("handlers:team:member", redis: Lita.redis)
      end

      def create(member_name:, team_name:)
        redis.hsetnx("#{ team_name}:#{ member_name }", :name, member_name)
      end

      def count(team_name:)
        redis.keys("#{ team_name }:*").count
      end

      def destroy(member_name:, team_name:)
        redis.del("#{ team_name }:#{ member_name }") != 0
      end

      def destroy_all(team_name:)
        redis.keys("#{ team_name }:*").each do |key|
          redis.del(key)
        end
      end

      def all(team_name:)
        redis.keys("#{ team_name }:*").sort.map do |key|
          data = redis.hgetall(key)
          model.new(data["name"])
        end
      end

      private

      def model
        Lita::Member
      end

    end
  end
end
