{
  "brand": "kvm",
  "vcpus": 2,
  "alias": "bgch-build",
  "hostname": "bgch-build",
  "autoboot": true,
  "ram": 2048,
  "resolvers": ["192.168.1.26", "8.8.8.8"],
  "disks": [
    {
      "image_uuid": "c864f104-624c-43d2-835e-b49a39709b6b",
      "boot": true,
      "model": "virtio",
      "size": 40960
    }
  ],
  "nics": [
    {
      "nic_tag": "admin",
      "model": "virtio",
      "ip": "192.168.1.79",
      "netmask": "255.255.255.0",
      "gateway": "192.168.1.1",
      "primary": 1
    }
  ],
   "customer_metadata": {
     "user-script" : "ELIDED"
   }
}
