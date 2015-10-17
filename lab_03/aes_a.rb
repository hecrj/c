require_relative 'aes'

# We use a random message and a random key
M = (0...16).map { Random.rand(2**8) }
K = (0...16).map { Random.rand(2**8) }
C = AES.encrypt(M, K)

# Generate all 128 * 128 variations of the message
M_ = (0...128).map do |i|
  (0...128).map do |j|
    mij = M.dup

    mij[15 - i / 8] ^= (1 << (i % 8))
    mij[15 - j / 8] ^= (1 << (j % 8)) unless i == j

    mij
  end
end

# We check that the statement is not true
(0...128).each do |i|
  (0...128).each do |j|
    raise "Failed with i = #{i} and j = #{j}" if AES.encrypt(M_[i][i], K) ^ AES.encrypt(M_[j][j], K) ^ AES.encrypt(M_[i][j], K) == C
  end
end

# We redefine sub_bytes as the identity
module AES
  def self.sub_bytes(bytes)
    bytes
  end
end

# Reencrypt the message
C_ = AES.encrypt(M, K)

# And now we check the statement is true
(0...128).each do |i|
  (0...128).each do |j|
    next if i == j
    raise "Failed with i = #{i} and j = #{j}" unless AES.encrypt(M_[i][i], K) ^ AES.encrypt(M_[j][j], K) ^ AES.encrypt(M_[i][j], K) == C_
  end
end

puts "All OK"
