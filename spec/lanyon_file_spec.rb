require 'spec_helper'

describe Lanyon::File, fakefs: true do

  before(:each) do
    Dir.mkdir('/root')
    Dir.mkdir('/root/path')

    File.write('/root/path/file.md', "# Hello World!\n...")
  end

  let(:file) { Lanyon::File.new('path/file.md', 'oid_val', '/root') }
  let(:file_with_content) do
    Lanyon::File.new('path/file.md', 'oid_val', '/root', true)
  end

  describe '#initialize' do
    it 'provides content by reading from disk' do
      expect(file_with_content.content).to eql "# Hello World!\n..."
      expect(file.content).to be_falsey
    end
  end

  describe '#read' do
    it 'reads the file content off disk' do
      expect(file.read).to eql "# Hello World!\n..."
    end

    it 'does nothing if the file isn\'t there' do
      file = Lanyon::File.new('bad/path', 'oid', '/')
      expect(file.read).to be_nil
    end
  end

  describe '#write' do
    it 'writes file contents to #system_path' do
      file.content = 'Hello Worlds!'
      file.write
      expect(::File.read('/root/path/file.md')).to eql 'Hello Worlds!'
    end
  end

  describe '#move' do
    it 'moves the file to a new path' do
      old_path = file.system_path
      file.move('bar.md')
      new_path = file.system_path
      expect(::File.exist?(new_path)).to be true
      expect(::File.exist?(old_path)).to be false
    end
  end
end
