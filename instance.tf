data "aws_key_pair" "buildsvr_key"{
    include_public_key = true
    filter {
        name   = "tag:key"
        values = ["key"]
    }
}



resource "aws_instance" "buildsvr" {
  ami           = "ami-0ea5eb4b05645aa8a" # ap-northeast-2 Ubuntu Server 20.04 LTS x64(x86)
  instance_type = "t2.medium" # 인스턴스 유형
  key_name      = data.aws_key_pair.buildsvr_key.key_name 
  availability_zone = aws_subnet.GoormProject-Public1.availability_zone # Worker Node와 동일한 VPC, AZ
  associate_public_ip_address = true # IP 자동 부여 활성화
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = "10"
    volume_type = "gp2"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo mkdir /var/lib/jenkins
                sudo mount /dev/vg0/lv0 /var/lib/jenkins
                sudo apt-get update -y && sudo apt-get install -y openjdk-11-jre
                curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
                echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt-get update -y && sudo apt-get install jenkins -y
                sudo apt-get update
                sudo apt-get install ca-certificates curl gnupg lsb-release
                sudo mkdir -p /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
                apt-cache madison docker-ce
                sudo apt-get install docker-ce=5:20.10.16~3-0~ubuntu-focal docker-ce-cli=5:20.10.16~3-0~ubuntu-focal containerd.io docker-compose-plugin -y
                sudo gpasswd -a jenkins docker
                sudo systemctl daemon-reload
                sudo systemctl restart docker
                sudo service jenkins restart
                curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
                sudo mv kustomize /usr/local/bin 
                EOF
  tags = {
    Name = "Build Server"
  }
}
resource "aws_eip" "by_allocation_id" {
  vpc = true
  id = "eipalloc-0b7a0bf5c15f6d539"
  instance = "${aws_instance.buildsvr.id}"
}
