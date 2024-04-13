resource "aws_instance" "node01" {
  ami           = "ami-0dbc3d7bc646e8516"
  instance_type = "t2.micro"
  key_name      = "my_key_personal"
  provisioner "file" {
    source      = "/home/eflores/.ssh/my-key-testing"
    destination = "/home/ec2-user/.ssh/id_rsa"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/eflores/.ssh/my_key_personal.pem")
      host        = self.public_dns
    }
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${self.public_dns}",
      "echo ''",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/my_key_personal.pem")
      host        = self.public_dns
    }
  }
  tags = {
    Name = "Testing server upload key"
  }
}
