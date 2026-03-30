namespace :git do
  desc 'Prepare changelogs for next release'
  task :changelog do
    sh 'git add CHANGELOG.md'
    sh "git commit -m 'chore(changelog): update with changes of next release'"
  end
end
