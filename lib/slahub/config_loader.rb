module Slahub
  module ConfigLoader
    def self.load
      YAML.load_file(File.expand_path("~/.config/slahub/slahub.yaml"))
    end
  end
end
