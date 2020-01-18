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
          github_v3_client: github_v3_client,
          issue_to_channel: -> (_issue) { channel }
        )
      end
    end

    private def github_access_token
      raise NotImplementedError
    end

    private def github_v3_client
      raise NotImplementedError
    end

    private def queries
      config['queries']
    end

    private
    attr_reader :config
  end
end
