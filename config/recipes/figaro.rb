namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    transfer :up, "#{RAILS_ROOT}/config/application.yml", "#{shared_path}/config/application.yml", :via => :scp
  end

  desc "Symlink application.yml to the release path"
  task :finalize do
    run "ln -sf #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
end