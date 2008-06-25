def logout(config,data)
  if config.include?("mes")
    $log.info(config["mes"])
    return data
  end
  return data
end
