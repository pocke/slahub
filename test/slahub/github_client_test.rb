require 'test_helper'

class GithubClientTest < Minitest::Test
  def test_v3_search
    c = Slahub::GithubClient.new(github_access_token: 'xxx')
    assert c.v3_search.respond_to?(:search_issues)
  end
end
