module Slahub
  class GithubClient
    def initialize(github_access_token:)
      @github_access_token = github_access_token
    end

    def v3
      @v3 ||= Octokit::Client.new(access_token: @github_access_token)
    end

    def v4
      raise NotImplementedError
    end
  end
end
