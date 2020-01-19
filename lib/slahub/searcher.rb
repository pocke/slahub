module Slahub
  class Searcher
    def initialize(query:, github_client:, issue_to_channel:)
      @query = query
      @github_client = github_client
      @issue_to_channel = issue_to_channel
    end

    def search(last_updated_at:)
      raise NotImplementedError
    end
  end
end
