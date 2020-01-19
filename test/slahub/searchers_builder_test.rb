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

  def test_build_3
    begin
      config_base = Slahub::ConfigLoader.load
    rescue Errno::ENOENT
      skip
    end
    config = config_base.dup.tap do |c|
      c['queries'] = [
        'query_dynamic' => 'watching',
      ]
    end

    github_client = Slahub::GithubClient.new(github_access_token: config['github_access_token'])
    searchers = Slahub::SearchersBuilder.new(config: config, github_client: github_client).build

    assert searchers.is_a?(Array)
    assert searchers.size > 0
    assert(searchers.all? { |s| s.is_a? Slahub::Searcher })
  end
end
