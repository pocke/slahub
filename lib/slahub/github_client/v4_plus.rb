module Slahub
  class GithubClient
    # High level GitHub API v4 client.
    class V4Plus
      WATCHING_REPOSITORIES_QUERY = <<~GRAPHQL
        query($first: Int!, $after: String) {
          viewer {
            watching(first: $first, after: $after) {
              nodes {
                nameWithOwner
              }
              pageInfo {
                endCursor
                hasNextPage
              }
            }
          }
        }
      GRAPHQL

      def initialize(low_client:)
        @low_client = low_client
      end

      def all_watching_repositories
        after = nil
        has_next_page = true
        repos = []

        while has_next_page
          resp = @low_client.execute query: WATCHING_REPOSITORIES_QUERY, variables: { first: 100, after: after }
          watching = resp[:data][:viewer][:watching]
          repos.concat watching[:nodes]
          has_next_page = watching[:pageInfo][:hasNextPage]
          after = watching[:pageInfo][:endCursor]
        end

        repos
      end
    end
  end
end
