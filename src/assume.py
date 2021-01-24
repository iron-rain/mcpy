import os
import json
import getpass
import requests
import xmltodict
import configparser

from icecream import ic

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

config = configparser.RawConfigParser()
config.read('settings.conf')


ep = config.get('oidc', 'OIDC_ENDPOINT')
client = config.get('oidc', 'OIDC_CLIENT')
minio_ep = config.get('minio', 'MINIO_ENDPOINT')
mc_config_path = config.get('minio', 'CONFIG_PATH')

username = input("Username: ")
userpass = getpass.getpass(prompt='Password: ')

def generate_oidc_token(username, password, endpoint, client):
    data = {'grant_type': 'password',
            'client_id': client,
            'username': username,
            'password': password}

    r = requests.post(endpoint, data=data, verify=False)

    access_token = json.loads(r.text)['access_token']

    return access_token


access_token = generate_oidc_token(username, userpass, ep, client)

def generate_minio_tokens(endpoint, access_token):
    data = {
        'Action': 'AssumeRoleWithWebIdentity',
        'DurationSeconds': 3600,
        'WebIdentityToken': access_token,
        'Version': '2011-06-15'
    }

    r = requests.post(endpoint, data=data, verify=False)

    o = xmltodict.parse(r.text)

    tokens = json.loads(json.dumps(o))

    access_key = tokens['AssumeRoleWithWebIdentityResponse']['AssumeRoleWithWebIdentityResult']['Credentials']['AccessKeyId']
    secret_key = tokens['AssumeRoleWithWebIdentityResponse']['AssumeRoleWithWebIdentityResult']['Credentials']['SecretAccessKey']
    session_token = tokens['AssumeRoleWithWebIdentityResponse']['AssumeRoleWithWebIdentityResult']['Credentials']['SessionToken']
    expiration = tokens['AssumeRoleWithWebIdentityResponse']['AssumeRoleWithWebIdentityResult']['Credentials']['Expiration']
    
    return access_key, secret_key, session_token, expiration

tokens = generate_minio_tokens(minio_ep, access_token)

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

print("")
print(bcolors.HEADER + "----------------------------------------------------------------------------------------------------------" + bcolors.ENDC)
print(bcolors.OKGREEN + "Temporary credentials created, to access your S3 resources copy and paste the lines below into a terminal." + bcolors.ENDC)
print("")
print(bcolors.FAIL + "export MC_HOST_minio=https://{}:{}:{}@minio.local".format(tokens[0], tokens[1], tokens[2]) + bcolors.ENDC)
print("")
print(bcolors.OKGREEN + "To access your S3 resources the following commands can be used after pasting the text above:" + bcolors.ENDC)
print(bcolors.OKGREEN + "    * mc ls minio/BUCKET" + bcolors.ENDC)
print(bcolors.OKGREEN + "    * mc cp FILE minio/BUCKET/FILE" + bcolors.ENDC)
print(bcolors.OKGREEN + "    * mc cp minio/BUCKET/FILE ." + bcolors.ENDC)
print(bcolors.HEADER + "----------------------------------------------------------------------------------------------------------" + bcolors.ENDC)