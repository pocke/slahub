module Slahub
  class Controller
    def initialize(config)
      @config = config
    end

    def run
      Models::ApplicationRecord.establish_connection

      github_client = build_github_client

      search_result_queue = Thread::Queue.new

      searchers = SearchersBuilder.new(config: @config, github_client: github_client).build
      searchers.each do |s|
        with_thread do
          loop do
            q = Models::Query.fetch_by_query(s.query)
            results = s.search(last_updated_at: q.newest_issue_updated_at)
            results.each do |result|
              search_result_queue << result
            end
            q.update!(newest_issue_updated_at: results.last.issue.updated_at) if results.present?
          end
        end
      end

      sleep
    end

    private def build_github_client
      access_token = @config['github_access_token']
      GithubClient.new(github_access_token: access_token)
    end

    private def with_thread(&block)
      Thread.new do
        Models::ApplicationRecord.connection_pool.with_connection do
          block.call
        end
      end
    end
  end
end
