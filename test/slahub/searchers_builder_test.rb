require 'test_helper'

class SearcherBuilderTest < Minitest::Test
  def test_build_1
    config = {
      'github_access_token' => "xxxx",
      'queries' => [],
    }
    github_client_stub = nil

    searchers = Slahub::SearchersBuilder.new(config: config, github_client: github_client_stub).build
    assert searchers.empty?
  end

  def test_build_2
    config = {
      'github_access_token' => "xxxx",
      'queries' => [
        { "query" => "involves:pocke", 'channel' => 'github-me', 'priority' => 100 },
        { "query" => "user:rubocop-hq", 'channel' => 'github-rubocop', 'priority' => 80 },
      ],
    }
    github_client_stub = nil

    searchers = Slahub::SearchersBuilder.new(config: config, github_client: github_client_stub).build
    assert_equal 2, searchers.size
    assert(searchers.all? { |s| s.is_a? Slahub::Searcher })
  end
end
