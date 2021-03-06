require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "bio-bwa"
  gem.homepage = "http://github.com/fstrozzi/bioruby-bwa"
  gem.license = "MIT/GPLv3"
  gem.summary = %Q{Ruby binding for BWA mapping software}
  gem.description = %Q{Ruby binding for BWA mapping software, built using Ruby-FFI library}
  gem.email = "francesco.strozzi@gmail.com"
  gem.authors = ["Francesco Strozzi"]
  gem.extensions = "ext/mkrf_conf.rb"
  gem.files += Dir['lib/**/*'] + Dir['ext/**/*'] 

  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

task :test do
  Dir.glob("test/**/test_*.rb").sort.each do |test|
    system("ruby "+test)
  end
end


require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-bwa #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
