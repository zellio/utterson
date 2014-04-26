require 'spec_helper'

describe Lanyon::File do

  let (:file) { Lanyon::File.new path: 'path/to/foo.md' }
  let (:dir)  { Lanyon::File.new path: 'path/to/foo/' }

  it 'subclasses ::File' do
    expect(Lanyon::File.ancestors.include? File).to be_true
  end

  describe '#basename' do
    it 'returns the basename of the file' do
      expect(file.basename).to eql "foo.md"
    end
  end

  describe '#dirname' do
    it 'returns the directory which contains the file' do
      expect(file.dirname).to eql 'path/to'
    end
  end

  describe '#file?' do
    it 'returns true if @path points to a file' do
      expect(file.file?).to be_true
      expect(dir.file?).to be_false
    end
  end

  describe '#directory?' do
    it 'returns true if the file is a directory' do
      expect(file.file?).to be_false
      expect(dir.file?).to be_true
    end
  end

  describe '#to_json' do
    it
  end

end
