namespace :pictures do
  task :copy do
    sh "scp lt:/var/wiffled/rails/current/public/pictures/* public/pictures/"
  end
end