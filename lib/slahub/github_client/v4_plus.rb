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

      ISSUE_TIMELINE_ITEMS_QUERY = <<~GRAPHQL
        query($issueId: ID!, $first: Int!, $after: String) {
          node(id: $issueId) {
            __typename
            ... on Issue {
              timelineItems(first: $first, after: $after, itemTypes: [ISSUE_COMMENT]) {
                nodes {
                  __typename
                  ... on IssueComment {
                    bodyText
                    author {
                      login
                    }
                  }
                }
                pageInfo {
                  endCursor
                  hasNextPage
                }
              }
            }

            ... on PullRequest {
              timelineItems(first: $first, after: $after, itemTypes: [ISSUE_COMMENT, PULL_REQUEST_REVIEW]) {
                nodes {
                  __typename
                  ... on IssueComment {
                    bodyText
                    author {
                      login
                    }
                  }
                  ... on PullRequestReview {
                    bodyText
                    author {
                      login
                    }
                  }
                }
                pageInfo {
                  endCursor
                  hasNextPage
                }
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

      # TODO: pagination
      def timeline_items(id)
        @low_client.execute query: ISSUE_TIMELINE_ITEMS_QUERY, variables: { first: 100, issueId: id }
      end
    end
  end
end
