namespace :rb do
  desc 'Format code using rubocop'
  task :format do
    sh 'bundle exec rubocop -A'
    sh 'git add .'
    sh 'git commit -m "format(rubocop): apply suggested corrections"'
  end
end
