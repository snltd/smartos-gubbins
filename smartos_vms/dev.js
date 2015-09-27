{
 "brand": "joyent",
 "image_uuid": "4166f6d6-ea5f-11e4-addd-8351b159d9b6",
 "alias": "rdfisher",
 "hostname": "rdfisher",
 "max_physical_memory": 512,
 "quota": 20,
 "resolvers": ["192.168.1.26", "8.8.8.8"],
 "nics": [
  {
    "nic_tag": "admin",
    "ip": "192.168.1.82",
    "netmask": "255.255.255.0",
    "gateway": "192.168.1.1"
  }
 ],
 "customer_metadata": {
    "authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBq6nG+D+1orRWf8xoWY2E/jRAS0taZDcmZ2OOG9vBCsC4BhJX0y3la9oiXVNfYYZGhyIfuhiwKef2lUf8KPShCEr05knRczmWvEnPbe81LEbmHFMmQzhLSSSqLWx+ttdetX9GNM4w0RxqqFggIalddbGBhZ65le3lFMLI8BhaWAf4vtsOL6z2mHOAtWgeKhsahuVWUKXx13M8HJkrvmS4p6KQ4Y5uD9kLnpQClDIYcdGg8xu0N/eShJtRww7JETyFFkTDHBrBYni+kdfVt0s//rpQbNX+Lx2XdGWjsxss+/1LDg2N/151KWrV8z4jDdS0pYm2h+EkGa9oFH3FJR9X",
    "user-script" : "echo '%sysadmin ALL=(ALL) NOPASSWD: ALL' >>/opt/local/etc/sudoers;useradd -m -s /bin/ksh -c 'Robert Fisher' -u 264 -g 14 -P 'Primary Administrator' rob; /usr/sbin/mdata-get authorized_keys > ~rob/.ssh/authorized_keys; passwd -N rob; pkgin in ruby21-chef-12.0.3 ruby21-mime-types-2.4.3 "
 }
}
