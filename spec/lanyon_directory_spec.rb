require 'spec_helper'

describe Lanyon::Directory do
  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo) { Rugged::Repository.new(repo_dir) }

  around(:each) { |example| fakegit(repo_dir, &example) }

  let(:dir) { Lanyon::Directory.new('src', 'oval', repo) }

  describe '#initialize' do
    it
  end
end
