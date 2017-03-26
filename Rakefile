require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :zip do
  FileUtils.rm 'files.zip' if File.exist? 'files.zip'
  `zip -r files.zip app db/migrate config`
end
