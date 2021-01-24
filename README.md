# Minio Client In-Line Assume

This script enable end users to run the WebAssume API flow for Minio. 

Currently only Keycloak is supported as an OIDC provider. 
The Minio client must be installed and accessible to access Minio. 

Supports Windows and Linux systems. 

### Configuration
Copy the conf/settings.conf to:
    - Windows - C:\Users\<USER>\.mc-assume\settings.conf
    - Linux - /home/<USER>/.mc-assume/settings.conf

The config file path is the HOMEPATH (Windows) or HOME (Linux) appended
    to .mc-assume/settings.conf

### Running the script
Requires Python 3.6+.

Run the following from inside this cloned repository:

- Windows:
    - python.exe -m venv venv
    - venv/Scripts/activate
    - pip install -r src/requirements.txt
    - python src/assume.py

- Linux
    - python -m venv venv
    - source venv/bin/activate
    - pip install -r src/requirement.txt
    - python src/assume.py 

A new shell will be created and the user will then be able to run Minio
    `mc` commands.