def grep(config,data)
  regex = Regexp.new(config["regex"])
  invert = config["invert"] || false
  data.select {|i| invert ^ (regex =~ i.to_s) }
end

