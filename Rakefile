require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :spec

directory "pkg"

desc "Make ptcp.exe file"
task :exe => "pkg" do
  sh %{ ocra exe/ptcp lib/**/*.rb }
  #sh "mkdir -p pkg"
  sh %{ mv ptcp.exe pkg/ }
end
