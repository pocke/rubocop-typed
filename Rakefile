require "bundler/gem_tasks"
task :default => [:build_deps, :spec]

task :build_deps do
  sh 'bundle check || bundle install', chdir: 'vendor/ruby-signature'
  sh 'bundle exec rake parser', chdir: 'vendor/ruby-signature'
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Generate a new cop with a template'
task :new_cop, [:cop] do |_task, args|
  require 'rubocop'

  cop_name = args.fetch(:cop) do
    warn 'usage: bundle exec rake new_cop[Department/Name]'
    exit!
  end

  github_user = `git config github.user`.chop
  github_user = 'your_id' if github_user.empty?

  generator = RuboCop::Cop::Generator.new(cop_name, github_user)

  generator.write_source
  generator.write_spec
  generator.inject_require(root_file_path: 'lib/rubocop/cop/typed_cops.rb')
  generator.inject_config(config_file_path: 'config/default.yml')

  puts generator.todo
end
