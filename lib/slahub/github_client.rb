module Slahub
  class GithubClient
    def initialize(github_access_token:)
      @github_access_token = github_access_token
    end

    def v3_search
      @v3_search ||= build_v3_search
    end

    def v4
      raise NotImplementedError
    end

    private def build_v3_search
      client = Octokit::Client.new(access_token: @github_access_token)
      ThrottledDelegator.new(wait: 10, concurrency: 2, to: client)
    end
  end
end
