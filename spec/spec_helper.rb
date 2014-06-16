require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lanyon'

require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end

require 'fileutils'

def fakegit(repo_dir, &block)
  source_repo = File.join(__dir__, 'testrepo')
  test_repo = repo_dir
  test_repo_git_dir = File.join(test_repo, '.git')

  FileUtils.mkdir_p(test_repo_git_dir)
  FileUtils.cp_r(File.join(source_repo, '.'), test_repo_git_dir)

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
