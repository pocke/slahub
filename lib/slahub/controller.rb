module Slahub
  class Controller
    def initialize(config)
      @config = config
    end

    def run
      searchers = SearchersBuilder.new(@config).build
      searchers.cycle.each do |s|
        s.search(last_updated_at: Time.now - 60 * 60 * 24)
      end
    end
  end
end
