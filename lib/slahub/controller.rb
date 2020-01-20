module Slahub
  class Controller
    def initialize(config)
      @config = config
    end

    def run
      Models::ApplicationRecord.establish_connection
      Slack.configure do |c|
        c.token = @config['slack_api_token']
      end

      github_client = build_github_client

      search_result_queue = Thread::Queue.new

      searchers = SearchersBuilder.new(config: @config, github_client: github_client).build
      searchers.each do |s|
        with_thread do
          loop do
            q = Models::Query.fetch_by_query(s.query)
            results = s.search(last_updated_at: q.newest_issue_updated_at)
            results.each do |result|
              search_result_queue << result
            end
            q.update!(newest_issue_updated_at: results.last.issue.updated_at) if results.present?
          end
        end
      end

      slack_client = Slack::Web::Client.new

      3.times do
        with_thread do
          while search_result = search_result_queue.pop
            id = search_result.issue.node_id
            posted_issue = Models::PostedIssue.find_or_create_by(node_id: id, channel_name: search_result.channel)

            unless posted_issue.thread_ts
              slack_resp = slack_client.chat_postMessage(channel: search_result.channel, text: search_result.issue.title)
              posted_issue.update!(thread_ts: slack_resp['ts'])
            end

            items = github_client.v4.timeline_items(id, after: posted_issue.latest_event_id)
            next if items.empty?

            posted_issue.update!(latest_event_id: items.last)
            items.each.with_index do |item, idx|
              case item[:__typename]
              when 'PullRequestReview', 'IssueComment'
                slack_client.chat_postMessage(
                  channel: search_result.channel,
                  text: "#{item[:bodyText]} by #{item[:author][:login]}",
                  thread_ts: posted_issue.thread_ts,
                  reply_broadcast: idx == items.size - 1,
                )
              else
                raise "Unknown type: #{item[:__typename]}"
              end
            end
          end
        end
      end

      sleep
    end

    private def build_github_client
      access_token = @config['github_access_token']
      GithubClient.new(github_access_token: access_token)
    end

    private def with_thread(&block)
      Thread.new do
        Models::ApplicationRecord.connection_pool.with_connection do
          block.call
        end
      end
    end
  end
end
