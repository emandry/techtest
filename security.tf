resource "aws_security_group" "merapar_public_web_allow" {
  name        = "merapar-public-web-allow"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.merapar.id

  tags = {
    Project = "Merapar"
  }
}


resource "aws_security_group_rule" "merapar_public_web_allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.merapar_public_web_allow.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

resource "aws_security_group_rule" "merapara_public_allow_all_traffic" {
  type              = "egress"
  security_group_id = aws_security_group.merapar_public_web_allow.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1" # semantically equivalent to all ports
  from_port         = 0
  to_port           = 65535
}


resource "aws_security_group" "merapar_private_web_allow" {
  name        = "merapar-private-web-allow"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.merapar.id

  tags = {
    Project = "Merapar"
  }
}

resource "aws_security_group_rule" "merapar_private_web_allow_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.merapar_private_web_allow.id
  source_security_group_id = aws_security_group.merapar_public_web_allow.id
  from_port                = 80
  protocol                 = "tcp"
  to_port                  = 80
}

resource "aws_security_group_rule" "merapara_private_allow_all_traffic" {
  type              = "egress"
  security_group_id = aws_security_group.merapar_private_web_allow.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1" # semantically equivalent to all ports
  from_port         = 0
  to_port           = 65535
}