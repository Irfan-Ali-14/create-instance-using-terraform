resource "aws_key_pair" "key-tf" {
  key_name   = "key-tf"
  public_key = file("${path.module}/your_generated_key.pub")
}


resource "aws_security_group" "allow_tls" {

  name        = "allow_tls"
  description = "Allow TLS inbound Trafic"

  dynamic "ingress" {
    for_each = [80, 22, 443, 3306, 27017]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
} 
resource "aws_instance" "example" {
  ami           = "ami-00448a337adc93c05"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key-tf.key_name


  tags = {
    Name = "server1"
  }
}

