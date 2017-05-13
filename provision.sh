sudo mkdir -p /apps/httpd/files/html
sudo mkfs -t ext4 /dev/xvdb
# mount filesystem to directory
sudo mount /dev/xvdb /apps/httpd/files/html
sudo cp /etc/fstab /etc/fstab.orig
    
# Add new line to file
sudo echo "/dev/xvdb /apps/httpd/files/html ext4 defaults,nofail 0 2" >> /etc/fstab

sudo yum -y install httpd
sudo chkconfig --add httpd

# replace document root location in /etc/httpd/conf/httpd.conf
# DocumentRoot "/var/www/html"
sudo sed -i 's/DocumentRoot \"\/var\/www\/html\"/# DocumentRoot \"\/var\/www\/html\"/g' /etc/httpd/conf/httpd.conf
sudo echo "DocumentRoot /apps/httpd/files/html" >> /etc/httpd/conf/httpd.conf
echo "Hello AWS World" >> /apps/httpd/files/html/index.html
sudo service httpd start
