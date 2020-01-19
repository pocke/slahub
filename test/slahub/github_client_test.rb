require 'test_helper'

class GithubClientTest < Minitest::Test
  def test_v3_search
    client = Slahub::GithubClient.new(github_access_token: 'xxx')
    assert client.v3_search.respond_to?(:search_issues)
  end

  def test_v4
    client = Slahub::GithubClient.new(github_access_token: 'xxx')
    assert client.v4.respond_to?(:all_watching_repositories)
  end
end
