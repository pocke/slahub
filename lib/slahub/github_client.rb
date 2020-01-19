module Slahub
  class GithubClient
    class LoggerMiddleware < Faraday::Middleware
      def call(request_env)
        resp = nil
        log_request request_env
        time = Benchmark.realtime do
          resp = @app.call(request_env)
        end
        resp.on_complete do |response_env|
          log_response response_env, time
        end
      end

      private def log_request(env)
        method = env.method.to_s.upcase
        Slahub.logger.info "--> #{method} #{env.url}"
      end

      private def log_response(env, time)
        t = time > 1 ? "#{time.round(2)}s" : "#{(time * 1000).round(2)}ms"
        Slahub.logger.info "<-- #{env.status} #{env.url} (#{t})"
      end
    end

    def initialize(github_access_token:)
      @github_access_token = github_access_token
    end

    def v3_search
      @v3_search ||= build_v3_search
    end

    def v4
      @v4 ||= build_v4
    end

    private def build_v3_search
      client = Octokit::Client.new(access_token: @github_access_token)
      client.middleware = Faraday::RackBuilder.new do |builder|
        builder.use ::Octokit::Middleware::FollowRedirects
        builder.use ::Octokit::Response::RaiseError
        builder.use ::Octokit::Response::FeedParser
        builder.use LoggerMiddleware
        builder.adapter Faraday.default_adapter
      end

      ThrottledDelegator.new(wait: 10, concurrency: 2, to: client)
    end

    private def build_v4
      client = V4.new(github_access_token: @github_access_token)
      delegated = ThrottledDelegator.new(wait: 1, concurrency: 2, to: client)
      V4Plus.new(low_client: delegated)
    end
  end
end
