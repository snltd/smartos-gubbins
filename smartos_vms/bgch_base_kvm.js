{
  "brand": "kvm",
  "vcpus": 2,
  "alias": "bgch-base",
  "hostname": "bgch-base",
  "autoboot": true,
  "ram": 2048,
  "resolvers": ["192.168.1.26", "8.8.8.8"],
  "disks": [
    {
      "image_uuid": "143e254a-b185-4d0c-9785-d924f4dc0a0d",
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
