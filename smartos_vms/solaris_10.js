{ 
   "brand": "kvm", 
   "ram": "2048", 
   "vcpus": "2", 
   "autoboot": false,
   "nics": [ 
     { 
       "nic_tag": "admin", 
       "model": "e1000", 
       "primary": true,
       "netmask": "255.255.255.0"
     } 
   ], 
   "disks": [ 
     { 
       "boot": true, 
       "model": "ide", 
       "size": 20480 
     } 
   ] 
}
