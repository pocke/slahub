module Slahub
  class Controller
    def initialize(config)
      @config = config
    end

    def run
      github_client = build_github_client

      searchers = SearchersBuilder.new(config: @config, github_client: github_client).build
      searchers.cycle.each do |s|
        # TODO
        s.search(last_updated_at: Time.now - 60 * 60 * 24)
      end
    end

    private def build_github_client
      access_token = config['github_access_token']
      GithubClient.new(github_access_token: access_token)
    end
  end
end
