require 'spec_helper'

describe Lanyon::File do

  let (:file) { Lanyon::File.new path: 'path/to/foo.md' }

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
    it
  end

  describe '#directory?' do
    it
  end

  describe '#to_json' do
    it
  end

end
