class Lanyon::FileCollection < ::Array
  def initialize(index)
    super index.map { |data| Lanyon::File.new(data[:path], data[:oid]) }
  end

  def files_in(path)
    select {|f| f.dirname == path }
  end

  def directories_in(path)
    map {|f| f.dirname[%r{(#{path}/[^/]+)}, 1] }.compact.uniq
  end

  def ls(path)
    directories_in(path) + files_in(path)
  end

  def ls_r(path)
    select {|f| f.dirname.index(path) == 0 }
  end
end
