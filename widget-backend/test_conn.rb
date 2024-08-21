require 'oci8'

begin
  conn = OCI8.new('C##widget_user', 'usernew', '//localhost/app')
  puts 'Connection successful!'
  conn.logoff
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace
end
