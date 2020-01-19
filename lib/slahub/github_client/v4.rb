module Slahub
  class GithubClient
    # Low level GitHub API v4 client.
    class V4
      class RequestError < StandardError
        def initialize(errors)
          @errors = errors
        end

        def message
          @errors.map{|e| e[:message]}.join("\n")
        end
      end

      def initialize(github_access_token:)
        @github_access_token = github_access_token
      end

      # TODO: logging
      def execute(query:, variables: {})
        http = Net::HTTP.new('api.github.com', 443)
        http.use_ssl = true
        header = {
          "Authorization" => "Bearer #{@github_access_token}",
          'Content-Type' => 'application/json',
        }
        resp = http.request_post('/graphql', JSON.generate({ query: query, variables: variables }), header)
        JSON.parse(resp.body, symbolize_names: true).tap do |content|
          raise RequestError.new(content[:errors]) if content[:errors]
        end
      end
    end
  end
end
