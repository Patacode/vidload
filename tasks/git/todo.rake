import File.expand_path('todo/update.rake', __dir__)

namespace :git do
  desc 'Prepare todo for next release'
  task :todo do
    sh 'git add TODO.md'
    sh "git commit -m 'chore(todo): checkmark achieved tasks'"
  end
end
