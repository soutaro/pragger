require "yaml"
def LoadFile(config,data)
  return YAML.load_file(config["filename"]) || []
end

