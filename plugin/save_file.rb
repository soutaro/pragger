require "yaml"
def save_file(config,data)
  File.open(config["filename"],"w") do |w|
    YAML.dump(data,w)
  end
  return data
end

