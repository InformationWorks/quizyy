root = "/home/deployer/apps/ashram-quizyy/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.ashram-quizyy.sock"
worker_processes 2
timeout 60