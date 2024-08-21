require 'active_record'
require 'ruby-oci8'
require 'activerecord-oracle_enhanced-adapter'
require 'logger'

# Enable detailed logging
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Define database configuration
db_config = {
  adapter: 'oracle_enhanced',
  username: 'C##widget_user',
  password: 'usernew',
  host: 'localhost',
  database: 'app'
}

# Print the configuration for debugging purposes
puts "DB Config: #{db_config.inspect}"

# Check for nil values in configuration
db_config.each do |key, value|
  if value.nil?
    puts "Warning: The configuration parameter #{key} is nil"
  end
end

# Establish the connection
begin
  ActiveRecord::Base.establish_connection(db_config)
  connection = ActiveRecord::Base.connection
  puts "Connection active: #{connection.active?}"
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
end
