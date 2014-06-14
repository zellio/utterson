require 'spec_helper'

describe Lanyon::RepositoryManager  do

  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo_manager) { Lanyon::RepositoryManager.new(repo_dir) }

  let(:foid) { '9eec82ced116713a102a04307e7e18d2509f8698' }
  let(:doid) { '591c274b49158e1a7dfcc962c190e3f347ee37dd' }

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe '#initialize' do
    it
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

  describe '#get' do
    let(:lfile) { repo_manager.file('README.md') }
    let(:ldir) { repo_manager.directory('src') }

    it 'Returns Lanyon::File' do
      expect(lfile).to be_a Lanyon::File
    end

    it 'Returns Lanyon::Directory' do
      expect(ldir).to be_a Lanyon::Directory
    end

    it 'Looks up stuff by name' do
      expect(lfile.oid).to eql foid
      expect(ldir.oid).to eql doid
    end

    it 'Treats empty as the root directory' do
      root = repo_manager.get
      expect(root).to be_a(Lanyon::Directory)
      expect(root.oid).to eql 'ec3161e34c15377c878da3d385f1baad10071513'
    end

    it 'Returns nil if traget doesn\'t exist' do
      expect(repo_manager.file('fake_file')).to be_nil
      expect(repo_manager.file('fake_dir')).to be_nil
    end
  end

  describe '#add' do
    let(:path) { 'file.txt' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:content) { 'Hello world!' }

    before(:each) { @commit = repo_manager.add(path, content) }

    it 'creates a file with content at target path' do
      expect(::File.exists?(full_path)).to be true
      expect(::File.read(full_path)).to eql content
    end

    it 'commits the new file to the controlled repository' do
      expect(repo_manager.repo.head.target).to eql @commit
    end

    it 'returns nil if the file exists' do
      expect(repo_manager.add('README.md', '')).to be_nil
    end
  end

  describe '#update' do
    let(:path) { 'README.md' }
    let(:full_path) { ::File.join(repo_dir, path) }
    let(:content) { 'Hello world!' }

    before(:each) { @commit = repo_manager.update(path, content) }

    it 'updates the content of a target file' do
      expect(::File.read(full_path)).to eql content
    end

    it 'returns nil if the file doesn\'t already exist' do
      expect(repo_manager.update('bad_path', content)).to be_nil
    end

    it 'commits  the updates to the controlled repository' do
      expect(repo_manager.repo.head.target).to eql @commit
    end
  end

  describe '#move' do
    let(:path) { 'README.md' }
    let(:full_path) { ::File.join(repo_dir, path) }

    let(:target) { 'readme.mdown' }
    let(:full_target) { ::File.join(repo_dir, target) }

    before(:each) do
      ::File.write(full_path, "\n# This is testing repository\n\n...")
      @commit = repo_manager.move(path, target)
    end

    it 'moves a file to a new location' do
      expect(::File.exist?(full_path)).to be false
      expect(::File.exist?(full_target)).to be true
    end

    it 'returns nil if the file doesn\'t exist' do
      expect(repo_manager.move('bad_path', '')).to be_nil
    end

    it 'returns nil if the target exist already' do
      expect(repo_manager.move('README.md', 'README.md')).to be_nil
    end

    it 'commits  the updates to the controlled repository' do
      expect(repo_manager.repo.head.target).to eql @commit
    end
  end

  describe '#delete' do
    it
  end
end
