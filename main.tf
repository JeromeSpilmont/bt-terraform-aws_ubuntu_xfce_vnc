

#Providers
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.region 
}

#Data
data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

variable "ubuntu_account_number" {
  default = "099720109477"
}




#resources
#Default vpc

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "allow_ssh_and_vnc" {
    name = "allow_ssh_vnc"
    description = "allow ssh & vnc on ports 22 & 5901"
    vpc_id = aws_default_vpc.default.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5901
        to_port = 5901
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
  
  
}

resource "aws_instance" "ubuntu_server" {
  ami             = data.aws_ami.ubuntu-18_04.id 
  instance_type   = "t2.micro" 
  key_name        = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_vnc.id] 

  tags = {
    Name = var.instance_name
  }

  #user_data - upgrade et installations de base sur l'instance 
  #user_data = file("./userdata.sh")

  connection {
    type   = "ssh"
    host  = self.public_ip
    user   ="ubuntu"
    private_key = file(var.private_key_path)
  } 
}



# OUTPUTS
# Public DNS
output "aws_instance_public_dns" {
    value = aws_instance.ubuntu_server.public_dns 
}


# Connecting the instanace from local system
resource "null_resource" "nullremote1" {
  depends_on = [ aws_instance.ubuntu_server ]

  connection {
    type   = "ssh"
    host  = aws_instance.ubuntu_server.public_dns
    user   ="ubuntu"
    private_key = file(var.private_key_path)
  } 

  #copying the xstartup script to the aws instance from local system
  provisioner "file" {
    source = "scripts/xstartup.sh"
    destination = "/home/ubuntu/xstartup"
  }

  #copying the vnc daemon conf to the aws instance from local system
  provisioner "file" {
    source = "scripts/daemon"
    destination = "/home/ubuntu/daemon"
  }

  #copying init-script.sh to the aws instance from local system
  provisioner "file" {
    source = "scripts/init.sh"
    destination = "/home/ubuntu/init.sh"
  }


  #copying init-script.sh to the aws instance from local system
  provisioner "file" {
    source = "scripts/script.sh"
    destination = "/home/ubuntu/script.sh"
  }

  #run the init script on remote instance
  provisioner "remote-exec" {
    inline = [
      "sh /home/ubuntu/init.sh"
    ]     
  }

}

# script 2
resource "null_resource" "nullremote2" {
  depends_on = [ aws_instance.ubuntu_server ]

  connection {
    type   = "ssh"
    host  = aws_instance.ubuntu_server.public_dns
    user   ="ubuntu"
    private_key = file(var.private_key_path)
  } 

  #run the script on remote instance
  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "sh /home/ubuntu/script.sh"
    ]     
  }

}