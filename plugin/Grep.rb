def Grep(config,data)
  regex = Regexp.new(config["regex"])
  return data.delete_if {|i| !(regex === i.to_s ) }
end

