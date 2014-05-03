class Lanyon::FileCollection < ::Array
  def initialize(index)
    super index.map { |data| Lanyon::File.new(data[:path], data[:oid]) }
  end

  def in(path)
    []
  end

  def read(oid)
    @file = find { |x| x.oid == oid }
    unless @file.nil?
      @file.contents = File.read(@file.path) unless @file.contents
      @file
    end
  end
end
