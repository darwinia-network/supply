require_relative './supplies'

task default: %w[supplies]

desc 'Looped calc darwinia supplies and write the result to the `supplies.json` file'
task :supplies do
  loop do
    File.write(File.join(__dir__, 'supplies.json'), supplies.to_json)
    sleep 60 * 5
  rescue StandardError => e
    puts e.message
    puts e.backtrace.join("\n")
  end
end

desc 'Calc darwinia supplies and write the result to the `supplies.json` file'
task :supplies_once do
  b = Time.now
  File.write(File.join(__dir__, 'supplies.json'), supplies.to_json)
  e = Time.now
  puts "elapsed: #{e - b}"
end
