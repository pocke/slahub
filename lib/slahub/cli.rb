module Slahub
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      config = ConfigLoader.load
      Controller.new(config).run
    end
  end
end
