require 'spec_helper'

describe Lanyon::FileCollection do

  let(:dir) { Rugged::Repository.discover('.') }
  let(:repo) { Rugged::Repository.new(dir) }
  let(:file_collection) { Lanyon::FileCollection.new(repo) }

  describe '#initialize' do
  end

  describe '#ls' do
    let(:files) { file_collection.ls("") }

    it 'lists the repo files of target path' do
      #TODO: Improve this spec
      expect(files.count).to be 13
      expect(files[0].path).to eql '.gitignore'
    end
  end

  describe '#get' do
    it 'reads a file by oid from the collection' do
      file = file_collection.ls("")[0]
      expect(file_collection.get(file.oid)).to eql file
    end

    it 'reutns nil if the oid doesn\'t exist' do
      expect(file_collection.get('bad oid')).to be_nil
    end
  end

  describe '#to_json' do
    it
  end
end
