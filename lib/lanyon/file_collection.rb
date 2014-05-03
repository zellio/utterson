class Lanyon::FileCollection < ::Array
  def initialize(index)
    super index.map { |data| Lanyon::File.new(data[:path], data[:oid]) }
  end

  def in(path)
    []
  end
end
