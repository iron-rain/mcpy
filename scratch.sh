mc admin config set local identity_openid config_url=https://keycloak.local/auth/realms/master/.well-known/openid-configuration client_id=minio claim_name=policy claim_prefix= scopes=email,profile jwks_url= 

mc admin service restart local