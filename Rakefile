require "bundler/gem_tasks"
task :default => [:build_deps, :'test:smoke']

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

task :update_submodules do
  Dir['vendor/*/'].each do |dir|
    sh 'git', 'fetch', 'origin', chdir: dir
    sh 'git', 'checkout', 'origin/master', chdir: dir
  end
end

task :'test:smoke' do
  require 'open3'
  require 'tempfile'

  dir = 'smoke'
  sh 'bundle check || bundle install', chdir: dir
  stdout, = Open3.capture2('bundle exec rubocop --cache false --format simple', chdir: dir).tap do |_, status|
    raise "Unexpected status: #{status}" if status.exitstatus != 1
  end

  lines = stdout.lines
  lines.pop # Remove "N files inspected, N offenses detected"

  wrong_tests = []
  lines.slice_when { |_, after| after.match?(/^== .+ ==$/) }.each do |path_line, *lines|
    actual = lines.join.chomp('')

    path = path_line[/^== (.+) ==$/, 1]
    expected_path = path.sub('test', 'smoke/expected').sub(/\.rb$/, '.txt')
    expected = File.read(expected_path).chomp('')

    if expected != actual
      binding.irb
      Tempfile.open do |f|
        f.write(actual)
        f.flush
        system "git diff --no-index #{expected_path} #{f.path}"
        wrong_tests << path
      end
    end
  end

  unless wrong_tests.empty?
    puts "Test failed with the following files"
    puts wrong_tests
    exit 1
  end
end
