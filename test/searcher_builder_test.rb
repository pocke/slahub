require 'test_helper'

class SearcherBuilderTest < Minitest::Test
  def test_build_1
    config = {
      'github_access_token' => "xxxx",
      'queries' => [],
    }

    searchers = Slahub::SearchersBuilder.new(config).build
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

    searchers = Slahub::SearchersBuilder.new(config).build
    assert_equal 2, searchers.size
    assert(searchers.all? { |s| s.is_a? Slahub::Searcher })
  end
end
