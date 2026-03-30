namespace "git:format" do
  desc 'Save code formatting/refactoring'
  task :update do
    sh 'git add .'
    sh 'git commit -m "format(rubocop): apply suggested corrections"'
  end
end
