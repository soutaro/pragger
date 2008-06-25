$reg = YAML.load(File.read("regist.yaml").toutf8) rescue Hash.new

def registry(config,data)
  $reg.update(config["file"]) if config.include?("file")
  $reg.update(config) if !config.include("file")
  return data
end
