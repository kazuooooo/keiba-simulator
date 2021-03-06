# deploy:starting
# deploy:started
# deploy:updating
# deploy:updated
# deploy:publishing
# deploy:published
# deploy:finishing
# deploy:finished

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'keiba-simulator'
set :repo_url, 'https://github.com/kazuooooo/keiba-simulator.git'
set :user, 'ubuntu'
set :deploy_to, '/var/www/keiba-simulator'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :ssh_options, {
  keys: %w(~/.ssh/keiba-2.pem),
  forward_agent: true,
}
# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('/home/vagrant/app_root/current/tmp/unicorn.pid')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('/var/www/keiba-simulator/current')

# Default value for default_env is {}
set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.2.4'
set :rbenv_path, '/opt/rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
# deploy:publicshingの後にdeploy:restartするという意味
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  # ブロック内の処理が実行された後に:resutartと:clear_cacheを呼ぶという意味
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart do
    # unicorn
    invoke 'unicorn:reload'
    # application
    on roles(:app), in: :sequence, wait: 5 do
      execute :mkdir, '-p', release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # namespace :assets do
  #   task :precompile, :roles => :web, :except => { :no_release => true } do
  #     from = source.next_revision(current_revision)
  #     if capture("cd #{latest_release} && #{source.local.log(from)} app/assets/ | wc -l").to_i > 0
  #       run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #     else
  #       logger.info "Skipping asset pre-compilation because there were no asset changes"
  #     end
  #   end
  # end
end

namespace :setup do

  desc "Upload database.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
    end
  end

  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:seed"
        end
      end
    end
  end

  desc "Symlinks config files for Nginx and Unicorn."
  task :symlink_config do
    on roles(:app) do
      execute "rm -f /etc/nginx/sites-enabled/default"

      execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
   end
  end

  desc "scp secret.yml"
  task :scp_secret_yml do
    run_locally do
      execute "sudo scp -i ~/.ssh/keiba-3.pem /Users/matsumotokazuya/desktop/keiba-simulator/config/secret.yml ubuntu@52.193.168.195:/var/www/keiba-simulator/current/config/secret.yml"
    end
  end
end
