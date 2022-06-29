#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "buildpack-cluster" {
  name = "${var.resource_prefix}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "buildpack-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.buildpack-cluster.name
}

resource "aws_iam_role_policy_attachment" "buildpack-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.buildpack-cluster.name
}

resource "aws_security_group" "buildpack-cluster" {
  name        = "${var.resource_prefix}-buildpack-eks-cluster-sg"
  description = "Cluster communication sg with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}-buildpack-eks-sg"
  }
}

resource "aws_security_group_rule" "buildpack-cluster-ingress-workstation-https" {
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.buildpack-cluster.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_eks_cluster" "buildpack" {
  name     = "${var.resource_prefix}-${var.cluster_name}"
  version  = 1.22
  role_arn = aws_iam_role.buildpack-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.buildpack-cluster.id]
    subnet_ids         = [var.subnet_id1, var.subnet_id2]
  }

  depends_on = [
    aws_iam_role_policy_attachment.buildpack-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.buildpack-cluster-AmazonEKSVPCResourceController,
  ]
}


