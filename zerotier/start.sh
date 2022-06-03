#!/bin/bash
IP_ADDR=$(dig +short txt ch whoami.cloudflare @1.0.0.1 | tr -d "\"")
echo "Public IP address: $IP_ADDR"
stableEndpointsForSed="\"$IP_ADDR\/9993\""
echo "{\"settings\": {\"portMappingEnabled\": true,\"softwareUpdate\": \"disable\",\"allowManagementFrom\": [\"0.0.0.0/0\"]}}" > /var/lib/zerotier-one/local.conf
if [ -d "/var/lib/zerotier-one/moons.d" ] # check if the moons conf has generated
then
  moon_id=$(cat /var/lib/zerotier-one/identity.public | cut -d ':' -f1)
  echo -e "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
  /usr/sbin/zerotier-cli orbit $moon_id $moon_id
  /usr/sbin/zerotier-one
else
  nohup /usr/sbin/zerotier-one >/dev/null 2>&1 &
  # Waiting for identity generation...'
  while [ ! -f /var/lib/zerotier-one/identity.secret ]; do
    sleep 1
  done
  /usr/sbin/zerotier-idtool initmoon /var/lib/zerotier-one/identity.public >>/var/lib/zerotier-one/moon.json
  sed -i 's/"stableEndpoints": \[\]/"stableEndpoints": ['$stableEndpointsForSed']/g' /var/lib/zerotier-one/moon.json
  /usr/sbin/zerotier-idtool genmoon /var/lib/zerotier-one/moon.json > /dev/null
  mkdir /var/lib/zerotier-one/moons.d
  mv *.moon /var/lib/zerotier-one/moons.d/
  moon_id=$(cat /var/lib/zerotier-one/moon.json | grep \"id\" | cut -d '"' -f4)
  echo -e "Your ZeroTier moon id is \033[0;31m$moon_id\033[0m, you could orbit moon using \033[0;31m\"zerotier-cli orbit $moon_id $moon_id\"\033[0m"
  /usr/sbin/zerotier-cli orbit $moon_id $moon_id
  pkill zerotier-one
  exec /usr/sbin/zerotier-one
fi
