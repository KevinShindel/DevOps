#!/bin/bash
yum -y update
yum -y install httpd
myip=$(curl "https://icanhazip.com/")
cat <<EOF > /var/www/html/index.html
<html>
<h2>WebServer with IP: $myip</h2><br/><small>Build by Terraform" </small>
<p>Owner: <b>${f_name} ${l_name}<b/> <br/>
%{ for x in names ~}
Hello to {x} from {f_name}<br>
%{endfor ~}
</html>
EOF
sudo service httpd start
chkconfig httpd on