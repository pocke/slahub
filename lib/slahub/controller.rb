module Slahub
  class Controller
    def initialize(config)
      @config = config
    end

    def run
      github_client = build_github_client

      search_result_queue = Thread::Queue.new

      searchers = SearchersBuilder.new(config: @config, github_client: github_client).build
      searchers.each do |s|
        Thread.new do
          loop do
            # TODO: set last_updated_at
            s.search(last_updated_at: Time.now - 60 * 60 * 24).each do |result|
              search_result_queue << result
            end
          end
        end
      end

      sleep
    end

    private def build_github_client
      access_token = @config['github_access_token']
      GithubClient.new(github_access_token: access_token)
    end
  end
end
