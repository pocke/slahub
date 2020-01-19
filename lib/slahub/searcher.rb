module Slahub
  class Searcher
    SearchResult = Struct.new(:issue, :channel, keyword_init: true)

    def initialize(query:, github_client:, issue_to_channel:)
      @query = query
      @github_client = github_client
      @issue_to_channel = issue_to_channel
    end

    def search(last_updated_at:)
      last_updated_at = last_updated_at.dup
      last_updated_at.utc
      q = build_query(last_updated_at: last_updated_at)
      @github_client.v3_search.search_issues(q, sort: 'updated', order: 'asc', per_page: 100).items.map do |item|
        SearchResult.new(issue: item, channel: @issue_to_channel.call(item))
      end
    end

    def build_query(last_updated_at:)
      updated = last_updated_at.iso8601
      "#{@query} updated:>=#{updated}"
    end
  end
end
