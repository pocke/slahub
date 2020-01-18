module Slahub
  class Searcher
    def initialize(query:, github_client:, issue_to_channel:)
      @query = query
      @github_client = github_client
      @issue_to_channel = issue_to_channel
    end

    def search
      # TODO
      last_updated_at = Time.now
      p last_updated_at
      raise NotImplementedError
    end
  end
end
