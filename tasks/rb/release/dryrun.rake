namespace "rb:release" do
  desc 'Dryrun release of new gem version'
  task :dryrun, [:bump_level] do |_t, args|
    args.with_defaults(bump_level: ENV['BUMP_LEVEL'] || 'patch')
    sh "./scripts/release-dryrun.sh #{args[:bump_level]}"
  end
end
