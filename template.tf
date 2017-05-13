provider "aws" {}
resource "aws_instance" "httpd" {
    ami = "ami-1e299d7e"
    instance_type = "t2.micro"
    tags {
        Name = "httpd"
    }
   key_name = "debashis1982-new"
provisioner "file" {
      source = "provision.sh"
      destination = "/tmp/provision.sh"
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
  provisioner "remote-exec" {
     inline = [
       "sudo chmod 755 /tmp/provision.sh",
       "sudo sh -c /tmp/provision.sh"
     ]
  connection {
            host = "${aws_instance.httpd.public_ip}"
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
         }
}

