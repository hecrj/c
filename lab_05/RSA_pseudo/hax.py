from Crypto.PublicKey.RSA import construct

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

# To extract n and e:
# openssl rsa -pubin -inform PEM -text -noout < hector.ramon_pubkeyRSA_pseudo.pemopenssl rsa -pubin -inform PEM -text -noout < hector.ramon_pubkeyRSA_pseudo.pem

# Factor n and change this values
P = (9734708213678047339, 16)
Q = (237722232539831678160480975771558179669, 8)
e = 65537

# Compute private key
p = P[0] ** P[1]
q = Q[0] ** Q[1]

euler_p = P[0] ** (P[1] - 1) * (P[0] - 1)
euler_q = Q[0] ** (Q[1] - 1) * (Q[0] - 1)

n = p * q

euler_n = euler_p * euler_q
d = inverse(e, euler_n)

private_key = construct((n, e, d, p, q))
print(private_key.exportKey().decode('utf-8'))

# To decrypt:
# openssl rsautl -decrypt -in hector.ramon_RSA_pseudo.enc -out hector.ramon_RSA_pseudo.txt -inkey hector.ramon_privkeyRSA_pseudo.pem
