require_relative 'aes'

# We redefine mix_columns as the identity
module AES
  def self.mix_columns(bytes)
    bytes
  end
end

# When we do this, then every byte of the original message will only
# affect the same byte in the encrypted messages
# We can test this easily

# We use a random message and a random key
M = (0...16).map { Random.rand(2**8) }
K = (0...16).map { Random.rand(2**8) }

# We encrypt the original messsage
C = AES.encrypt(M, K)

# For every byte of the message
(0...16).each do |b|
  # We generate all the combinations for that byte
  ms = (0...8).map do |bit|
    mi = M.dup
    mi[15 - b] ^= (1 << bit)
    mi
  end

  # We encrypt all the different messages
  cs = ms.map { |m| AES.encrypt(m, K) }

  # We find where the two first encrypted messages differ
  different_byte = cs[0].zip(cs[1]).map { |b1, b2| b1 != b2 }.find_index(true)

  # And now, we check that all the encrypted messages change only in this
  # particular byte
  cs.each_with_index do |c1, i|
    cs.each_with_index do |c2, j|
      next if i == j

      differences = c1.zip(c2).map { |b1, b2| b1 != b2 }

      raise "Not only one byte changed" unless differences.count(true) == 1
      raise "The bytes that changed don't share the same position" unless differences[different_byte]
    end
  end
end

puts "All OK"
