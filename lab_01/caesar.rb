require_relative 'support'

module Caesar
  def self.candidates(cryptogram, n=5)
    cryptogram.most_frequent_chars.map do |char, _|
      ALPHABET[(char.ord - 'E'.ord) % 26]
    end
  end
end

puts Caesar.candidates(File.read(ARGV[0]).cryptogram)
