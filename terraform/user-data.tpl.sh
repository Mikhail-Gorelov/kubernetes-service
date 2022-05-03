#!/bin/bash
yum -y update
yum -y install httpd
cat <<EOF > /var/www/html/index.html
<html>
Owner ${f_name} ${l_name}<br>
%{ for x in names ~}
Hello to ${x} <br>
%{ endfor ~}
</html>
EOF
sudo service httpd start
chkconfig httpd on