from Crypto.Cipher import AES
from sys import argv

_, key_file, encrypted_file = argv

key = open(key_file, 'rb').read()
content = open(encrypted_file, 'rb').read()
iv, cryptogram = content[0:16], content[16:]
cipher = AES.new(key, AES.MODE_OFB, iv)

print(cipher.decrypt(cryptogram).decode('utf-8'), end='')
