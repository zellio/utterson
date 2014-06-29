require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lanyon'

require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end

require 'fileutils'
require 'rugged'

def fakegit(repo_dir, &block)
  source_repo = File.join(__dir__, 'testrepo')
  test_repo = repo_dir

  Rugged::Repository.clone_at(source_repo, test_repo)

  Dir["#{test_repo}/**/*"].each { |f| File.chmod(0644, f) if File.file?(f) }

  yield if block_given?

  FileUtils.rm_r(test_repo)
end

ENV['RACK_ENV'] = 'test'

require 'rack/test'

module Rack::Test::Methods
  def app
    Lanyon::Application
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, rackup: true
end
