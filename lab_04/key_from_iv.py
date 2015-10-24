from Crypto.Cipher import AES
from sys import argv

_, encrypted_file = argv

content = open(encrypted_file, 'rb').read()
iv, cryptogram = content[0:16], content[16:]

for kiv in range(256):
    candidate_key = bytes(list(map(lambda ivb: ivb ^ kiv, iv)))
    cipher = AES.new(candidate_key, AES.MODE_CBC, iv)

    try:
        print(cipher.decrypt(cryptogram).decode('utf-8'), end='')
    except UnicodeDecodeError:
        continue
