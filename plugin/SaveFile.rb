require "yaml"
def SaveFile(config,data)
  File.open(config["filename"],"w") do |w|
    YAML.dump(data,w)
  end
  return data
end

