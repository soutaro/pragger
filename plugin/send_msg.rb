def send_msg(config, data)
  method = config['method'] || nil
  params = config['params'] || []
  
  data.collect {|x|
    method ? x.send(method, *params) : x
  }
end
