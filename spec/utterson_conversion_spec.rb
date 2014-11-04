require 'spec_helper'

describe Utterson::Conversion do
  let(:repo_dir) { File.join(__dir__, "spec_repo.#{Time.now.to_i}") }
  let(:repo) { Rugged::Repository.new(repo_dir) }

  let(:test_obj) do
    class UttersonConversionSpecClass
      include Utterson::Conversion

      def initialize(repo)
        @repo = repo
      end
    end

    UttersonConversionSpecClass.new(repo)
  end

  let(:dhash) do
    { type: :tree,
      name: 'src',
      oid: '591c274b49158e1a7dfcc962c190e3f347ee37dd' }
  end

  let(:fhash) do
    { type: :blob,
      name: 'README.md',
      oid: 'a72e8acf907100d4bdc6489f9215027b02369246' }
  end

  around(:each) { |example| fakegit(repo_dir, &example) }

  describe '#hash_to_utterson_class' do
    it 'converts a file hash to an Utterson::File' do
      obj = test_obj.send(:hash_to_utterson_class, fhash)
      expect(obj).to be_a Utterson::File
    end

    it 'converts a directory hash to an Utterson::Directory' do
      obj = test_obj.send(:hash_to_utterson_class, dhash)
      expect(obj).to be_a Utterson::Directory
    end
  end
end
