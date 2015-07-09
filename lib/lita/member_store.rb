module Lita
  module MemberStore
    extend self

    def redis
      @redis ||= Redis::Namespace.new(
        'handlers:team:member',
        redis: Lita.redis
      )
    end

    def create(team_name:, attrs:)
      key = attrs['mention_name'] || attrs['name']
      redis.hmset("#{team_name}:#{key}", *attrs.to_a.flatten)
    end

    def exist?(team_name:, member_name:)
      redis.exists("#{team_name}:#{member_name}")
    end

    def destroy(member_name:, team_name:)
      redis.del("#{team_name}:#{member_name}") != 0
    end

    def destroy_all(team_name:)
      redis.keys("#{team_name}:*").each do |key|
        redis.del(key)
      end
    end

    def all(team_name:)
      redis.keys("#{team_name}:*").sort.map do |key|
        redis.hgetall(key)
      end
    end
  end
end
