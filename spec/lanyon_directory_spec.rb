require 'spec_helper'

describe Lanyon::Directory, fakefs: true do

  before(:each) do
    Dir.mkdir('/root')
    Dir.mkdir('/root/path')
  end

  let(:repo) { }
  let(:dir) { Lanyon::Direcotry.new('path', 'oid_val', '/root') }
  let(:dir_with_content) do
    Lanyon::Directory.new('path', 'oid_val', repo, true)
  end

  describe '#initialize' do
  end

  describe '#content' do
    it
  end
end
