require 'test_helper'

class GithubClientTest < Minitest::Test
  def test_v3_search
    c = Slahub::GithubClient.new(github_access_token: 'xxx')
    assert c.v3_search.respond_to?(:search_issues)
  end

  def test_v4
    skip unless ENV['GITHUB_ACCESS_TOKEN']

    c = Slahub::GithubClient.new(github_access_token: ENV['GITHUB_ACCESS_TOKEN'])
    assert c.v4
  end
end
