def load_file(config,data)
  require "yaml"
  return YAML.load_file(config["filename"]) || []
end

