require 'spec_helper'

describe Lanyon::Directory do
  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo) { Rugged::Repository.new(repo_dir) }

  let(:oid) { '591c274b49158e1a7dfcc962c190e3f347ee37dd' }
  let(:dir) { Lanyon::Directory.new('src', oid, repo) }

  let(:foid) { 'a72e8acf907100d4bdc6489f9215027b02369246' }

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe '#read' do
    it 'reads the directory contents off disk' do
      content = dir.read
      expect(content.length).to be 1
      expect(content.first.oid).to eql foid
    end
  end
end
