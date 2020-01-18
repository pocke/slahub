module Slahub
  class SearchersBuilder
    def initialize(config)
      @config = config
    end

    def build
      queries.map do |q|
        query = q['query']
        channel = q['channel']

        Searcher.new(
          query: query,
          github_client: github_client,
          issue_to_channel: -> (_issue) { channel }
        )
      end
    end

    private def github_client
      @github_client ||= begin
        access_token = config['github_access_token']
        GithubClient.new(github_access_token: access_token)
      end
    end

    private def queries
      config['queries']
    end

    private
    attr_reader :config
  end
end
