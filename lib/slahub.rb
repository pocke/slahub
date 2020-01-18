require 'yaml'
require 'octokit'

require "slahub/version"
require 'slahub/cli'
require 'slahub/searcher'
require 'slahub/searchers_builder'
require 'slahub/github_client'

module Slahub
  class Error < StandardError; end
  # Your code goes here...
end
