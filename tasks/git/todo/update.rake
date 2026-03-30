namespace "git:todo" do
  desc 'Add/Update tasks in TODO.md'
  task :update do
    sh 'git add TODO.md'
    sh "git commit -m 'chore(todo): add/update tasks'"
  end
end
