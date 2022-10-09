require_relative './supplies'

task default: %w[supplies]

desc 'Calc darwinia supplies and write the result to the `supplies.json` file'
task :supplies do
  loop do
    File.write(File.join(__dir__, 'supplies.json'), supplies.to_json)
    sleep 60
  rescue StandardError => e
    puts e.message
    puts e.backtrace.join("\n")
  end
end
