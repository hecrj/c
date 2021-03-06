import re

def decode_hex(hex):
    return int('0x' + ''.join(re.sub('\n\s*\t*', '', hex).split(':')), base=16)

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

Qx, Qy = (
    decode_hex("""6b:fb:ee:c6:9d:e7:2c:66:a6:68:ec:e1:aa:f1:
         a2:64:a3:c9:b2:88:fb:32:d0:59:e9:2c:3e:5d:5b:
         d4:d7:b5:01:48:78:f4:47:9c:13:c8:83:d0:54:55:
         5c:d9:0e:cd"""),
    decode_hex("""13:6e:c4:cc:34:64:89:cd:d6:4e:69:
         43:f3:33:86:4a:b9:df:e4:42:dc:bf:8f:69:c1:9e:
         71:d0:35:ff:31:7f:c0:32:fc:21:55:ca:ea:a6:5b:
         49:3d:19:1d:39:9a:c0""")
)

q = decode_hex("""00:8c:b9:1e:82:a3:38:6d:28:0f:5d:6f:7e:50:e6:
                    41:df:15:2f:71:09:ed:54:56:b4:12:b1:da:19:7f:
                    b7:11:23:ac:d3:a7:29:90:1d:1a:71:87:47:00:13:
                    31:07:ec:53""")

a = decode_hex("""7b:c3:82:c6:3d:8c:15:0c:3c:72:08:0a:ce:05:af:
                    a0:c2:be:a2:8e:4f:b2:27:87:13:91:65:ef:ba:91:
                    f9:0f:8a:a5:81:4a:50:3a:d4:eb:04:a8:c7:dd:22:
                    ce:28:26""")

b = decode_hex("""04:a8:c7:dd:22:ce:28:26:8b:39:b5:54:16:f0:44:
                    7c:2f:b7:7d:e1:07:dc:d2:a6:2e:88:0e:a5:3e:eb:
                    62:d5:7c:b4:39:02:95:db:c9:94:3a:b7:86:96:fa:
                    50:4c:11""")

Px, Py = (
    decode_hex("""1d:1c:64:f0:68:cf:45:ff:a2:a6:3a:81:b7:c1:
                    3f:6b:88:47:a3:e7:7e:f1:4f:e3:db:7f:ca:fe:0c:
                    bd:10:e8:e8:26:e0:34:36:d6:46:aa:ef:87:b2:e2:
                    47:d4:af:1e"""),
    decode_hex("""8a:be:1d:75:20:f9:c2:a4:5c:b1:eb:
                    8e:95:cf:d5:52:62:b7:0b:29:fe:ec:58:64:e1:9c:
                    05:4f:f9:91:29:28:0e:46:46:21:77:91:81:11:42:
                    82:03:41:26:3c:53:15""")
)

n = decode_hex("""00:8c:b9:1e:82:a3:38:6d:28:0f:5d:6f:7e:50:e6:
                    41:df:15:2f:71:09:ed:54:56:b3:1f:16:6e:6c:ac:
                    04:25:a7:cf:3a:b6:af:6b:7f:c3:10:3b:88:32:02:
                    e9:04:65:65""")


Zq = Zmod(q)
E = EllipticCurve(Zq, [a, b])

Q = E([Qx, Qy])
P = E([Px, Py])

dni = '47894466'

# 1.
print "1."
print E
print "P =", P
print


# a)
r = int(dni * 8)
dni_pubkey = r * P
print "a) Q =", dni_pubkey

# b)
candidate = int(dni)
i = 1

while not E.lift_x(candidate, all=True):
    candidate = int(dni) * 10 ** (int(log(i, 10)) + 1) + i
    i = i + 1

print "b) Q =", E.lift_x(candidate)
print "   No es computacionalmente factible calcular la clave privada fácilmente a partir de la pública."

# c)
import random

k = random.randrange(2, q-1)
x1, y1, _ = k * P

f1 = int(mod(x1, q))
f2 = mod(inverse(k, q) * (decode_hex(dni) + f1 * r), q)
print "c) a: (f1, f2) =", (f1, f2)
print "   b: No puedo calcular la firma sin la clave privada."

# d)
print "d) Entiendo que aquí se realizaría el mismo proceso que se realizó con la PS4. Asumiendo que ambas firmas"
print "   se han obtenido usando una misma k. Pero no he sido capaz de computar la clave privada en el apartado"
print "   b), así que solo tengo una firma... :("

print

# 2.
print "2."
print E
print "P =", P
