require_relative './supplies'

task default: %w[supplies]

desc 'Calc darwinia supplies and write the result to the `supplies.json` file'
task :supplies do
  File.write(File.join(__dir__, 'supplies.json'), supplies.to_json)
end
