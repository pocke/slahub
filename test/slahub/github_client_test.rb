require 'test_helper'

class GithubClientTest < Minitest::Test
  def test_v3_search
    client = Slahub::GithubClient.new(github_access_token: 'xxx')
    assert client.v3_search.respond_to?(:search_issues)
  end

  def test_v4
    begin
      config = Slahub::ConfigLoader.load
    rescue Errno::ENOENT
      skip
    end
    client = Slahub::GithubClient.new(github_access_token: config['github_access_token'])
    assert client.v4
  end
end
