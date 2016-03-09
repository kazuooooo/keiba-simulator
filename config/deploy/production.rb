set :stage, :production

role :app, %w{ec2-user@52.192.198.145}
role :web, %w{ec2-user@52.192.198.145}
role :db,  %w{ec2-user@52.192.198.145}
set :unicorn_pid, "/var/www/keiba-simulator/current/tmp/unicorn.pid"
