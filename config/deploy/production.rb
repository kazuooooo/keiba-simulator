set :stage, :production

role :app, %w{ubuntu@52.193.168.195}
role :web, %w{ubuntu@52.193.168.195}
role :db,  %w{ubuntu@52.193.168.195}
set :unicorn_pid, "/var/www/keiba-simulator/current/tmp/unicorn.pid"
