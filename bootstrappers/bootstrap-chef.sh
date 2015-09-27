#!/usr/bin/ksh

# These creds don't work any more. Left lying around as an example.

exec 1>/var/tmp/bootstrap.log
exec 2>&1

echo '%sysadmin ALL=(ALL) NOPASSWD: ALL' >>/opt/local/etc/sudoers

wget -q --no-check-certificate -P /var/tmp \
	https://us-east.manta.joyent.com/snltd/public/snltd-ruby-2.2.3.tgz \

yes | /opt/local/sbin/pkg_add /var/tmp/snltd-ruby-2.2.3.tgz

echo "set -o vi" >> /root/.profile

mkdir /etc/chef

cat <<-EOCRB >/etc/chef/client.rb
	log_level                :info
	log_location             STDOUT
	node_name               'www-test.localnet'
	chef_server_url          "https://api.opscode.com/organizations/snltd"
	validation_client_name   "snltd-validator"
	validation_key           "/etc/chef/snltd-validator.pem"
EOCRB

cat <<-EOV >/etc/chef/snltd-validator.pem
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEApmSwncwNQkO16X73ClaRv38jtU6plSWUSEhq7Nvrcp2QW+1V
VB9R7p/2sHTyYuNP0ao9Sy5m0WjVoj7SO0+xRvJBYCcVspUsfK85tEc50L+FRsSn
xpFaEA6S1XkvGFbd44jH9RuS6ne0avKdzlE8awIDAQABAoIBAG8ZH8vcaKXr69RB
j9T5REtmKoNuSFBrTPyOTcZkeGqIxdB7QMPCadJl5YpyRg6vFkrju4OIgPnAhfzC
ANhm9JtCRtOuHtDyq/caSgsor4AmH7GTRXGFbezR2a1RBd72U51lIOjBLi6Llefr
zekqRzOhDOp82BmdhL8syHUlUmQAo1Ug48wCJlPL3cil4wuya9PenM7ng+NMjQvY
3ym0RnGOrIdKkxzR5OBfqVITAM9i3nRGuhsNgP3SojXebd+5dWi8tcp6O2bb4rU+
Bwij3FQeeHaOduxrzuTqSZK4QJy28hB9s3Y5Lzyad4FlkvDx7pTDePFWDgf52bZA
Hi6gYTECgYEA0Oq9NU0UNWM5wSsPWkarosN/Z75HCUrgzM/+ZaDBZu5MVaN60wN5
BknjMTd4kFS/QDNelMYRtD8IkD3NgazPd3byMH3V93/gUE7qZWce5Yzi35C5adBv
IB6PK1RNzcgzMVkLbBO3JwHBbOAEK7m98+lI6hzoM+Num9Y8bnKYgx0CgYEAy+SX
WiK3Ig/e7JYM6hpFGizRrG9afayUkOQ2zqDVQ+/v2qYYtjIIgti0dC53VMSWykCn
gOhikBr1mjt4QLbIkVpv+3Fpq7MTG0x4B143/26w6zSuVScJxYz6zFeEBVqbnbpz
0Chk2ylL8UVy1bjUAV/5pvyhgIbF4JGopQ0r3ycCgYA1oY0g+cCOVAKnjB5M1oeJ
xLZrIzCY4XGrn7uzvsdYIQKBgEdTShb/+exyfNtqik4CrpW/hAG8Wn2IN9iP3RRf
cvt3HgLxA8gIrK2JPWc/MgN3WgCaqX4QzRn4NF6l2yVYS8V9S5s8S2kDFfYAxCRf
s1spz74YCbxEEckHzlxZaReuYK3Goej5mH6KbcSTNN7K728jsePWkHCztNkgW0yR
1P0VAoGBAMYxCRiY/rskftekHtJzvrx3ymRs6sJ9n1h1Q15BkR9deqczp7Bk5bqb
2uPb9PbVZSfAu3e4v+kiFh+IF3ERfUo9lOx4k/fzbq8hN/4o3sDikP1uVNp4ZbTj
OqpUjEJZY8uWzcAio0ZbjCEt6/3yVGVRId+aMPNhgrKQCEOt8NrC
-----END RSA PRIVATE KEY-----
EOV

cat <<-EOJS >/etc/chef/firstboot.json
	{
		"run_list": [ "role[www]" ]
	}
EOJS

/opt/local/ruby/bin/chef-client -j /etc/chef/firstboot.json
