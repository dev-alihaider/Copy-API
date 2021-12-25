require 'rake'
Rake::Task.clear
CopyApi::Application.load_tasks
Rake::Task['refresh_data:copy'].invoke
