#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y

myip=$(curl "https://icanhazip.com/")
cd ~
cat <<EOF > index.html
<html>
<h2>WebServer with IP: $myip </h2><br/><small>Build by Terraform" </small>
<p>Owner: <b>${f_name} ${l_name}<b/> <br/>
%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}
</html>
EOF

#cd ~
#sudo echo "<html>
#<h2>WebServer with IP: $myip </h2>
#<br/>
#<small>Build by Terraform</small>
#<p>Owner: <b>${f_name} ${l_name}<b/> <br/>
#%{ for x in names ~}
#Hello to ${x} from ${f_name}<br>
#%{ endfor ~}
#</html>" > index.html

sudo mv index.html /var/www/html/
sudo service nginx start