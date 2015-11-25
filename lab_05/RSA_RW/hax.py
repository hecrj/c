from sys import argv
from fractions import gcd
from Crypto.PublicKey.RSA import importKey, construct
from glob import glob

# Load target key
target=importKey(open(argv[1]).read())

# Initialize p
p = 1

# Find common divisor with other keys
for filename in glob('*pubkey*.pem'):
    if filename != argv[1]:
        candidate = importKey(open(filename).read())
        p = gcd(target.n, candidate.n)

    if p != 1:
        break

q = target.n // p

if p * q != target.n:
    raise "Error computing p and q"

euler_n = target.n - (p + q - 1)

def inverse(a, n):
    t = 0
    r = n
    newt = 1
    newr = a

    while newr != 0:
        q = r // newr
        t, newt = newt, t - q * newt
        r, newr = newr, r - q * newr

    if r > 1:
        raise "a is not invertible"

    if t < 0:
        t = t + n

    return t

# Compute private exponent
d = inverse(target.e, euler_n)

# Generate private key
private_key = construct((target.n, target.e, d, p, q))
print(private_key.exportKey().decode('utf-8'))

# To decrypt:
# openssl rsautl -decrypt -in hector.ramon_RSA_RW.enc -out hector.ramon_RSA_RW.txt -inkey hector.ramon_privkeyRSA_RW.pem
