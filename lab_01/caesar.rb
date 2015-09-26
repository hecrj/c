require_relative 'support'

module Caesar
  def self.candidates(message, n=5)
    message.letters_only.most_frequent_chars[0...n].map do |char, _|
      ALPHABET[(char.ord - 'e'.ord) % 26]
    end
  end

  def self.decrypt(message, key)
    i = key.ord - ALPHABET[0].ord
    configuration = ALPHABET[i..-1] + ALPHABET[0...i]

    message.tr(configuration + configuration.upcase, ALPHABET + ALPHABET.upcase)
  end
end
