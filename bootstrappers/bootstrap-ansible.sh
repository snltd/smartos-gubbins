#!/usr/bin/ksh

useradd -m -s /bin/ksh -c 'Robert Fisher' -u 264 -g 14 \
	-P 'Primary Administrator' rob
passwd -N rob

echo '%sysadmin ALL=(ALL) NOPASSWD: ALL' >>/opt/local/etc/sudoers

cat <<-EOKEY >/home/rob/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBq6nG+D+1orRWf8xoWY2E/jRAS0taZDcmZ2OOG9vBCsC4BhJX0y3la9oiXVNfYYZGhyIfuhiwKef2lUf8KPShCEr05knRczmWvEnPbe81LEbmHFMmQzhLSSSqLWx+ttdetX9GNM4w0RxqqFggIalddbGBhZ65le3lFMLI8BhaWAf4vtsOL6z2mHOAtWgeKhsahuVWUKXx13M8HJkrvmS4p6KQ4Y5uD9kLnpQClDIYcdGg8xu0N/eShJtRww7JETyFFkTDHBrBYni+kdfVt0s//rpQbNX+Lx2XdGWjsxss+/1LDg2N/151KWrV8z4jDdS0pYm2h+EkGa9oFH3FJR9X
EOKEY
