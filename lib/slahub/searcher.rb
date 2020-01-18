module Slahub
  class Searcher
    # XXX: It requires GitHub API v3 because it cannot specify orderBy in v4, but we need it.
    def initialize(query:, github_v3_client:, issue_to_channel:)
      @query = query
      @github_v3_client = github_v3_client
      @issue_to_channel = issue_to_channel
    end

    def search
      # TODO
      last_updated_at = Time.now
      p last_updated_at
    end
  end
end
