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
      client = V4.new(github_access_token: @github_access_token)
      ThrottledDelegator.new(wait: 1, concurrency: 2, to: client)
    end
  end
end
