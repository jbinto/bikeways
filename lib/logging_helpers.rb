def debug(message)
  Rails.logger.debug(message)
  if ENV["DEBUG"]
    print message
  end
end
