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

    it 'Returns nil if traget doesn\t exist' do
      expect(repo_manager.file('fake_file')).to be_nil
      expect(repo_manager.file('fake_dir')).to be_nil
    end
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
