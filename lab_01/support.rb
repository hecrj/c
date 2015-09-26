ALPHABET = ('a'..'z').to_a.join

class String
  def most_frequent_chars(n=10)
    chars.frequencies[0..n]
  end

  def most_frequent_words(n=10)
    split.frequencies[0..n]
  end

  def distances(word)
    distances = []
    total = 0
    enum = split

    enum.each do |candidate|
      total += candidate.size

      if candidate == word
        distances << (distances.empty? ? total : total -  distances.last)
      end
    end

    distances
  end

  def cryptogram
    chomp.downcase.gsub(/[^a-z]/i, '')
  end
end

class Array
  def frequencies
    freqs = {}

    each do |element|
      freqs[element] ||= 0
      freqs[element] += 1
    end

    freqs.sort_by { |index, frequency| -frequency }
  end

  def gcd
    inject(first, :gcd)
  end
end
