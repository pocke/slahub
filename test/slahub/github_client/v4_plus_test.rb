require 'test_helper'

class V4PlusTest < Minitest::Test
  def v4_plus_client
    begin
      config_base = Slahub::ConfigLoader.load
    rescue Errno::ENOENT
      skip
    end

    low_client = Slahub::GithubClient::V4.new(github_access_token: config_base['github_access_token'])
    Slahub::GithubClient::V4Plus.new(low_client: low_client)
  end

  def test_all_watching_repositories
    repos = v4_plus_client.all_watching_repositories

    assert repos.is_a? Array
    assert repos.size > 0
    assert(repos.all? { |r| r[:nameWithOwner].is_a?(String) })
  end

  def test_timeline_items_issue
    # https://github.com/pocke/slahub/issues/5
    issue_id = 'MDU6SXNzdWU1NTIyNTg0MjY='

    items = v4_plus_client.timeline_items(issue_id)
    assert items.is_a? Array
    assert items.size > 0
    assert(items.all? { |i| i[:__typename].is_a?(String) })
  end

  def test_timeline_items_pull_request
    # https://github.com/pocke/slahub/pull/4
    issue_id = 'MDExOlB1bGxSZXF1ZXN0MzY0NzQ4Nzkx'

    items = v4_plus_client.timeline_items(issue_id)
    assert items.is_a? Array
    assert items.size > 0
    assert(items.all? { |i| i[:__typename].is_a?(String) })
  end
end
