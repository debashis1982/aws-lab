provider "aws" {}
resource "aws_instance" "httpd" {
    ami = "ami-1e299d7e"
    instance_type = "t2.micro"
    tags {
        Name = "httpd"
    }
   key_name = "debashis1982-new"
provisioner "remote-exec" {
     inline = [
	"sudo mkfs -t ext4 /dev/xvdb",
	"sudo mkdir -p /apps/httpd/files/html",
        "sudo mount /dev/xvdb /apps/httpd/files/html",
        "sudo cp /etc/fstab /etc/fstab.orig",
        "sudo echo /dev/xvdb /apps/httpd/files/html ext4 defaults,nofail 0 2 >> /etc/fstab",
        "sudo yum -y install httpd",
        "sudo sed -i 's/DocumentRoot \"\/var\/www\/html\"/# DocumentRoot \"\/var\/www\/html\"/g' /etc/httpd/conf/httpd.conf",
        "sudo echo DocumentRoot /apps/httpd/files/html >> /etc/httpd/conf/httpd.conf",
        "sudo echo Hello AWS World >> /apps/httpd/files/html/index.html",
        "sudo chkconfig --add httpd",
        "sudo service httpd start"
     ]
 	connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
   }
}
resource "aws_ebs_volume" "myebs" {
  availability_zone = "${aws_instance.httpd.availability_zone}"
  size              = 1
}
resource "aws_volume_attachment" "myebs_attach" {
  device_name = "/dev/sdb"
  volume_id   = "${aws_ebs_volume.myebs.id}"
  instance_id = "${aws_instance.httpd.id}"
}

