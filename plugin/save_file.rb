def save_file(config,data)
  require "yaml"
  File.open(config["filename"],"w") do |w|
    YAML.dump(data,w)
  end
  return data
end

