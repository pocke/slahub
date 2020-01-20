require 'yaml'
require 'time'
require 'json'
require 'logger'
require 'benchmark'

require 'octokit'
require 'active_record'

require 'slahub/cli'
require 'slahub/config_loader'
require 'slahub/controller'
require 'slahub/github_client'
require 'slahub/github_client/v4'
require 'slahub/github_client/v4_plus'
require 'slahub/searcher'
require 'slahub/searchers_builder'
require 'slahub/throttled_delegator'
require 'slahub/version'
require 'slahub/models/application_record'
require 'slahub/models/query'
require 'slahub/models/posted_issue'

module Slahub
  class Error < StandardError; end
  # Your code goes here...

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
