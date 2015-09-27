{
 "brand": "joyent",
 "image_uuid": "5c7d0d24-3475-11e5-8e67-27953a8b237e",
 "alias": "www-test",
 "hostname": "www-test",
 "max_physical_memory": 128,
 "quota": 20,
 "resolvers": ["192.168.1.26", "8.8.8.8"],
 "nics": [
  {
    "nic_tag": "admin",
    "ip": "192.168.1.88",
    "netmask": "255.255.255.0",
    "gateway": "192.168.1.1"
  }
 ],
 "customer_metadata": {
    "user-script": "curl -k https://us-east.manta.joyent.com/snltd/public/bootstrap-puppet.sh | sh"
 }
}
