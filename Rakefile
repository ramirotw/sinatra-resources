require "sinatra/activerecord/rake"
require "rake/testtask"
require "./app"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

desc "Run the app"
task :run do
  ResourcesApp.run!
end

desc "Re-seed db"
task :re_seed_db do
  Resource.delete_all
  Booking.delete_all
  seed_file = "./db/seed.rb"
  load(seed_file) if File.exist?(seed_file)
end