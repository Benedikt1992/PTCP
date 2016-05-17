require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :spec

directory "pkg"
directory "pkg/debug"

desc "Make ptcp.exe file"
task :exe => "pkg" do
  sh %{ ocra exe/ptcp lib/**/*.rb --quiet --console --icon media/terminal.ico}
  sh %{ mv ptcp.exe pkg/ }
end

desc "Make ptcp-debug.exe file"
task :exe_debug => "pkg/debug" do
  sh %{ ocra exe/ptcp lib/**/*.rb --console --debug-extract --debug}
  sh %{ mv ptcp-debug.exe pkg/debug/ }
end
