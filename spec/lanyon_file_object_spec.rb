require 'spec_helper'

describe Lanyon::FileObject, fakefs: true do

  before(:each) do
    Dir.mkdir('/root')
    Dir.mkdir('/root/path')

    File.write('/root/path/file.md', "# Hello world!\n...")
  end

  let(:file) { Lanyon::FileObject.new('path/file.md', 'oval', '/root') }
  let(:dir)  { Lanyon::FileObject.new('path', 'oval', '/root') }

  let(:file_with_content) do
    Lanyon::FileObject.new('path/file.md', 'oval', '/root', true)
  end

  describe '#system_path' do
    it 'is the full path of the file on disk' do
      expect(file.system_path).to eql '/root/path/file.md'
    end
  end

  describe '#basename' do
    it 'is the filename of the file' do
      expect(file.basename).to eql 'file.md'
    end
  end

  describe '#dirname' do
    it 'is the relative path of the file' do
      expect(file.dirname).to eql 'path'
    end
  end

  describe '#exists?' do
    it 'is true if the file exists' do
      expect(file.file?).to be true
    end

    it 'is false if the file does not exist' do
      bad_file = Lanyon::FileObject.new('bad', 'oval', '/root')
      expect(bad_file.exists?).to be false
    end
  end

  describe '#file?' do
    it 'is true if the FileObject points to a file' do
      expect(file.file?).to be true
    end

    it 'is false if the FileObject isn\'t a file' do
      expect(dir.file?).to be false
    end
  end

  describe '#directory?' do
    it 'is true if the FileObject points to a directory' do
      expect(dir.directory?).to be true
    end

    it 'is false if the FileObject isn\'t a file' do
      expect(file.directory?).to be false
    end
  end

  describe '#mode' do
    it 'is the mode of the file on disk' do
      mode = ::File::Stat.new(file.system_path).mode
      expect(file.mode).to eql mode
    end
  end

  describe '#flush_content' do
    it 'nulls the content of the file' do
      file.flush_content
      expect(file.content).to be_nil
    end
  end

  describe '#to_h' do
    let(:hash) { file.to_h }
    let(:chash) { file_with_content.to_h }

    it 'is a hash of the relevant public values' do
      expect(hash).to be_a(::Hash)
    end

    it 'provides the oid value' do
      expect(hash[:oid]).to eql 'oval'
    end

    it 'provides the path value' do
      expect(hash[:path]).to eql 'path/file.md'
    end

    it 'provides content value' do
      expect(hash[:content]).to be_falsey
      expect(chash[:content]).to be_truthy
    end
  end

  describe '#to_json' do
    it 'searlizes the to_h value' do
      expect(file.to_json).to eql '{"oid":"oval","path":"path/file.md","type":"file_object"}'
    end
  end

  describe '#eql?' do
    it 'compares object as a hash' do
      expect(file).to eql file.to_h
    end
  end
end
