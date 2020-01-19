module Slahub
  class GithubClient
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
        builder.response :logger
        builder.adapter Faraday.default_adapter
      end
      ThrottledDelegator.new(wait: 10, concurrency: 2, to: client)
    end

    private def build_v4
      http = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
        def headers(context)
          {
            "Authorization" => "Bearer #{context[:github_access_token]}"
          }
        end
      end

      schema = GraphQL::Client.dump_schema(http, context: { github_access_token: @github_access_token })

      GraphQL::Client.new(schema: schema, execute: http)
    end
  end
end
