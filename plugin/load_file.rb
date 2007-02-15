require "yaml"
def load_file(config,data)
  return YAML.load_file(config["filename"]) || []
end

