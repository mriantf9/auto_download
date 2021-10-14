from requests import Request, Session
import requests
import sys
# import re

# OUTPUT = "/mnt/c/Users/ehmurai/Documents/EHMURAI/sde_image_downloader/OUTPUT"

heder = {
    'Auth-Type': 'certificate',
    'Content-Type': 'image/jpeg'
}
file_cert = '/mnt/c/Users/ehmurai/Documents/sde_image_downloader/script/llama_cert.pem'
key_cert = '/mnt/c/Users/ehmurai/Documents/sde_image_downloader/script/llama.key'
certificate = (file_cert, key_cert)
url = sys.argv[1]
filename = sys.argv[2]
OUTPUT = sys.argv[3]

filenamefix = filename.translate(
    {ord(c): "_" for c in '!@#$%^&*()[];:,.<>/?|`~-=_+"'})




try:
    response = requests.get(url, cert=certificate, headers=heder)

    file = open(OUTPUT+filenamefix+".jpg", "wb")
    file.write(response.content)
    file.close()

 

    print(response)
except requests.exceptions.RequestException as e:  # This is the correct syntax
    raise SystemExit(e)
