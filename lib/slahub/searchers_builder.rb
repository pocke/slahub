module Slahub
  class SearchersBuilder
    def initialize(config:, github_client:)
      @config = config
      @github_client = github_client
    end

    def build
      queries.flat_map do |q|
        query = q['query']
        channel = q['channel']

        Searcher.new(
          query: query,
          github_client: @github_client,
          issue_to_channel: -> (_issue) { channel }
        )
      end
    end

    private def queries
      config['queries']
    end

    private
    attr_reader :config
  end
end
