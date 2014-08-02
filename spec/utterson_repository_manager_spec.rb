require 'spec_helper'

describe Utterson::RepositoryManager  do

  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo_manager) { Utterson::RepositoryManager.new(repo_dir) }

  let(:foid) { '9eec82ced116713a102a04307e7e18d2509f8698' }
  let(:doid) { '591c274b49158e1a7dfcc962c190e3f347ee37dd' }

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe '#author' do
    it 'contains the commiter\'s email' do
      expect(repo_manager.author[:email]).to eql 'utterson@localhost'
    end

    it 'contains the commiter\'s name' do
      expect(repo_manager.author[:name]).to eql 'Dr. Utterson'
    end

    it 'contains the current time' do
      Time.stub(:now) { Time.mktime(1970, 1, 1) }
      expect(repo_manager.author[:time]).to eql Time.now
    end
  end

  describe '#get' do
    let(:lfile) { repo_manager.file('README.md') }
    let(:ldir) { repo_manager.directory('src') }

    it 'Returns Utterson::File' do
      expect(lfile).to be_a Utterson::File
    end

    it 'Returns Utterson::Directory' do
      expect(ldir).to be_a Utterson::Directory
    end

    it 'Looks up stuff by name' do
      expect(lfile.oid).to eql foid
      expect(ldir.oid).to eql doid
    end

    it 'Returns nil if traget doesn\'t exist' do
      expect(repo_manager.file('fake_file')).to be_nil
      expect(repo_manager.file('fake_dir')).to be_nil
    end
  end

  describe '#add' do
    let(:path) { 'file.txt' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:file) { Utterson::File.new(path, nil, repo_dir) }
    let(:content) { 'Hello world!' }

    before(:each) { @commit = repo_manager.add(file, content) }

    it 'creates a file with content at target path' do
      expect(::File.exist?(full_path)).to be true
      expect(::File.read(full_path)).to eql content
    end

    it 'commits the new file to the controlled repository' do
      expect(repo_manager.repo.last_commit.oid).to eql @commit
    end
  end

  describe '#update' do
    let(:path) { 'README.md' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:file) { Utterson::File.new(path, '', repo_dir) }
    let(:bad_file) { Utterson::File.new('bad_path', '', repo_dir) }

    let(:content) { 'Hello world!' }

    before(:each) { @commit = repo_manager.update(file, content) }

    it 'updates the content of a target file' do
      expect(::File.read(full_path)).to eql content
    end

    it 'returns nil if the file doesn\'t already exist' do
      expect(repo_manager.update(bad_file, content)).to be_nil
    end

    it 'commits  the updates to the controlled repository' do
      expect(repo_manager.repo.last_commit.oid).to eql @commit
    end
  end

  describe '#move' do
    let(:path) { 'README.md' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:file) { Utterson::File.new(path, '', repo_dir) }

    let(:target) { 'readme.mdown' }
    let(:full_target) { ::File.join(repo_dir, target) }

    before(:each) do
      @commit = repo_manager.move(file, target)
    end

    it 'moves a file to a new location' do
      expect(::File.exist?(full_path)).to be false
      expect(::File.exist?(full_target)).to be true
    end

    it 'returns nil if the target exist already' do
      expect(repo_manager.move('README.md', 'README.md')).to be_nil
    end

    it 'commits  the updates to the controlled repository' do
      expect(repo_manager.repo.last_commit.oid).to eql @commit
    end
  end

  describe '#delete' do
    let(:path) { 'README.md' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:file) { Utterson::File.new(path, foid, repo_dir) }

    before(:each) do
      @commit = repo_manager.delete(file)
    end

    it 'deletes the file' do
      expect(::File.exist?(full_path)).to be false
    end

    it 'commits  the updates to the controlled repository' do
      expect(repo_manager.repo.last_commit.oid).to eql @commit
    end
  end
end
