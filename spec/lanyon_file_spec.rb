require 'spec_helper'

describe Lanyon::File do

  it 'subclasses ::File' do
    expect(Lanyon::File.ancestors.include? File).to be_true
  end

  describe '#basename' do
    it
  end

  describe '#dirname' do
    it
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
