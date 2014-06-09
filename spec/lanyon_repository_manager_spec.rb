require 'spec_helper'

describe Lanyon::RepositoryManager  do

  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo_manager) { Lanyon::RepositoryManager.new(repo_dir) }

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe '#initialize' do
    it '' do
    end
  end

  describe '#author' do
    it 'contains the commiter\'s email' do
      expect(repo_manager.author[:email]).to eql 'lanyon@localhost'
    end

    it 'contains the commiter\'s name' do
      expect(repo_manager.author[:name]).to eql 'Dr. Lanyon'
    end

    it 'contains the current time' do
      Time.stub(:now) { Time.mktime(1970, 1, 1) }
      expect(repo_manager.author[:time]).to eql Time.now
    end
  end

  describe '#file' do
    it
  end

  describe '#directory' do
  end

  describe '#add' do
    it
  end

  describe '#update' do
    it
  end

  describe '#move' do
    it
  end

  describe '#delete' do
    it
  end
end
