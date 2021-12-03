module Utils
  def self.read_integers(filename)
    File.readlines(filename).map(&:to_i)
  end
end
