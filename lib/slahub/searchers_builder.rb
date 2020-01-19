module Slahub
  class SearchersBuilder
    # GitHub does not accept too large URI,
    # so it should separate requests if the query is too long.
    # The limit is actually about 6800. I found this limit with binary searching with GitHub API.
    # This constant has leeway.
    GITHUB_URI_LIMIT_LENGTH = 5000

    def initialize(config:, github_client:)
      @config = config
      @github_client = github_client
    end

    def build
      queries.flat_map do |q|
        query = q['query']
        channel = q['channel']
        query_dynamic = q['query_dynamic']

        if query
          Searcher.new(
            query: query,
            github_client: @github_client,
            issue_to_channel: -> (_issue) { channel }
          )
        elsif query_dynamic == 'watching'
          build_watching channel: channel
        else
          raise "unknown query: #{q}"
        end
      end
    end

    private def build_watching(channel:)
      repos = @github_client.v4.all_watching_repositories
      queries = repositories_to_queries(repos)

      queries.map do |q|
        Searcher.new(
          query: q,
          github_client: @github_client,
          issue_to_channel: -> (_issue) { channel }
        )
      end
    end

    private def repositories_to_queries(repositories)
      q = +''
      qs = []
      repositories.each do |repo|
        if q.length > GITHUB_URI_LIMIT_LENGTH
          qs << q
          q = +''
        else
          q << "repo:#{repo[:nameWithOwner]}"
        end
      end
      qs << q unless q.empty?

      qs
    end

    private def queries
      config['queries']
    end

    private
    attr_reader :config
  end
end
