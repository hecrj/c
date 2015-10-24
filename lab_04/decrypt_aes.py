from Crypto.Cipher import AES
from sys import argv

_, key_file, encrypted_file = argv

key = open(key_file, 'rb').read()
cryptogram = open(encrypted_file, 'rb').read()
cipher = AES.new(key[0:16], AES.MODE_CBC, key[16:32])

print(cipher.decrypt(cryptogram).decode('utf-8'), end='')
