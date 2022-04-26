#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y

myip=$(curl "https://icanhazip.com/")
cd ~
cat <<EOF > index.html
<html>
<h2>WebServer with IP: $myip </h2>
<br/>
<p>Created by ${f_name} ${l_name}
<b> version 3.0 </b>
<br/>
<small>Build by Terraform </small>
<ul>
%{ for x in names ~}
<li>Hello to ${x} from ${f_name}</li>
%{ endfor ~}
</ul>
</html>
EOF
sudo mv index.html /var/www/html/
sudo service nginx start
