module Slahub
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      searchers = SearchersBuilder.new(config).build
      p searchers
    end

    private def config
      @config ||= YAML.load_file(File.expand_path("~/.config/slahub/slahub.yaml"))
    end
  end
end
