require 'spec_helper'

describe Lanyon::File, fakefs: true do

  before(:each) do
    Dir.mkdir('path')
    Dir.mkdir('path/to')
    Dir.mkdir('path/to/foo')

    File.write('path/to/foo.md', 'w')
  end

  let(:file) { Lanyon::File.new('path/to/foo.md') }
  let(:absf) { Lanyon::File.new('/abs/path') }
  let(:dir) { Lanyon::File.new('path/to/foo/') }

  describe '#path' do
    it 'prepends "./" to relative paths' do
      expect(file.path).to eql './path/to/foo.md'
      expect(absf.path).to eql '/abs/path'
    end
  end

  describe '#basename' do
    it 'returns the basename of the file' do
      expect(file.basename).to eql 'foo.md'
      expect(dir.basename).to eql 'foo'
    end
  end

  describe '#dirname' do
    it 'returns the directory which contains the file' do
      expect(file.dirname).to eql './path/to'
      expect(dir.dirname).to eql './path/to'
    end
  end

  describe '#file?' do
    it 'returns true the file is a file' do
      expect(file.file?).to be_true
      expect(dir.file?).to be_false
    end
  end

  describe '#directory?' do
    it 'returns true if the file is a directory' do
      expect(file.directory?).to be_false
      expect(dir.directory?).to be_true
    end
  end

  describe '#to_json' do
    it
  end

end
