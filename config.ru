# This file is used by Rack-based servers to start the application.

# Force Thin to log timestamps (to use the default log message format)
Thin::Logging.logger.formatter = nil

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
