import File.expand_path('release/dryrun.rake', __dir__)
import File.expand_path('release/local.rake', __dir__)

namespace :rb do
  desc 'Release new gem version'
  task :release, [:bump_level] do |_t, args|
    args.with_defaults(bump_level: ENV['BUMP_LEVEL'] || 'patch')
    sh "./scripts/release.sh #{args[:bump_level]}"
  end
end
