module Utterson::Conversion
  attr_reader :repo

  def hash_to_utterson_class(hash)
    case hash[:type]
    when :blob
      Utterson::File.new(hash[:name], hash[:oid], @repo.workdir, true)
    when :tree
      Utterson::Directory.new(hash[:name], hash[:oid], @repo, false)
    end
  end
  private :hash_to_utterson_class
end
