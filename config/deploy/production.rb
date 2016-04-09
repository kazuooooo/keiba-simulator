set :stage, :production

role :app, %w{ubuntu@52.193.91.187}
role :web, %w{ubuntu@52.193.91.187}
role :db,  %w{ubuntu@52.193.91.187}
set :unicorn_pid, "/var/www/keiba-simulator/current/tmp/unicorn.pid"
