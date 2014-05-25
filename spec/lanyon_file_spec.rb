require 'spec_helper'

describe Lanyon::File, fakefs: true do

  before(:each) do
    Dir.mkdir('/root')
    Dir.mkdir('/root/path')

    File.write('/root/path/foo.md', 'Hello world!')
  end

  let(:file) { Lanyon::File.new('/root', 'path/foo.md', 'oid') }

  describe '#initialize' do
    it 'reads file content from disk if not provided' do
      expect(file.content).to eql 'Hello world!'
    end
  end

  describe '#system_path' do
    it 'is the full path of the file on disk' do
      expect(file.system_path).to eql '/root/path/foo.md'
    end
  end

  describe '#basename' do
    it 'is the filename of the file' do
      expect(file.basename).to eql 'foo.md'
    end
  end

  describe '#dirname' do
    it 'is the relative path of the file' do
      expect(file.dirname).to eql 'path'
    end
  end

  describe '#exists?' do
    it 'is a wrapper around File.exists?' do
      expect(file.exists?).to be_true
    end
  end

  describe '#read' do
    it 'reads the file content off disk' do
      expect(file.read).to eql 'Hello world!'
    end

    it 'does nothing if the file isn\'t there' do
      file.path = 'bad/path'
      expect(file.read).to be_nil
    end
  end

  describe '#write' do
    it 'writes file contents to #system_path' do
      file.content = 'Hello Worlds!'
      file.write
      expect(::File.read('/root/path/foo.md')).to eql 'Hello Worlds!'
    end
  end

  describe '#move' do
    it 'moves the file to a new path' do
      old_path = file.system_path
      file.move('bar.md')
      new_path = file.system_path
      expect(::File.exist?(new_path)).to be_true
      expect(::File.exist?(old_path)).to be_false
    end
  end

  describe '#to_h' do
    let(:hash) { file.to_h }

    it 'is a hash of the relevant public values' do
      expect(hash).to be_a(::Hash)
    end

    it 'provides the oid value' do
      expect(hash[:oid]).to eql 'oid'
    end

    it 'provides the path value' do
      expect(hash[:path]).to eql 'path/foo.md'
    end

    it 'provides the content value' do
      expect(hash[:content]).to eql 'Hello world!'
    end
  end

  describe '#to_json' do
    it 'searlizes the to_hash value' do
      expect(file.to_json).to eql '{"oid":"oid","path":"path/foo.md","content":"Hello world!"}'
    end
  end
end
