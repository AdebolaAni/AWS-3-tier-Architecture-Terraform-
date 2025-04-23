/*

 #This code is to create an ec2 instance and add a bootstrap code

resource "aws_instance" "patty_more_ec2_web_server" {
  ami                         = "ami-07a6f770277670015"
  instance_type               = "t2.micro"
  key_name                    = "debby" #input the correct keypair later
  subnet_id                   = aws_subnet.patty_moore_public_subnet_az1a.id
  vpc_security_group_ids      = [aws_security_group.patty_moore_web_server_sg.id]
  associate_public_ip_address = true
 
  user_data                   = <<-EOF
    #!/bin/bash
    sudo su
    yum update -y
    yum install -y httpd
    cd /var/www/html
    wget https://github.com/Ahmednas211/jupiter-zip-file/raw/main/jupiter-main.zip
    unzip jupiter-main.zip
    cp -r jupiter-main/* /var/www/html
    rm -rf jupiter-main jupiter-main.zip
    systemctl start httpd
    systemctl enable httpd
  EOF


  tags = {
    Name = "patty-moore-ec2-web-server"
  }
} 

 */
