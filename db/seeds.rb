# db/seeds.rb

# Specify the module to run based on the environment variable
module_to_run = ENV['MODULE']

if module_to_run.blank?
  puts "Please provide the module name using the MODULE environment variable, e.g. 'rifamax' \n"
  puts "Available modules ['shared', 'rifamax', 'X100', 'fifty']"
  exit
end

# Load the specific seed folder or file dynamically
seed_path = File.join(Rails.root, 'db', 'seeds', module_to_run)
seed_files = Dir[File.join(seed_path, '*.rb')].sort

if seed_files.empty?
  puts "No seed files found for module '#{module_to_run}'"
  exit
end

seed_files.each do |seed_file|
  load seed_file
end
