{
 "brand": "joyent",
 "image_uuid": "5c7d0d24-3475-11e5-8e67-27953a8b237e",
 "alias": "build",
 "hostname": "build",
 "max_physical_memory": 2048,
 "quota": 200,
 "resolvers": ["192.168.1.26", "8.8.8.8"],
 "nics": [
  {
    "nic_tag": "admin",
    "ip": "192.168.1.89",
    "netmask": "255.255.255.0",
    "gateway": "192.168.1.1"
  }
 ],
 "customer_metadata": {
   "user-script": "crle -64 -u -l /opt/local/lib; /opt/local/bin/pkgin -y in mysql-client-5.6.25nb2 gcc48 gmake; /opt/local/bin/npm install manta -g >/var/tmp/log 2>&1"

 }
}
