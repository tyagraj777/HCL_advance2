#Task: Create redundant compute instances in multiple regions for disaster recovery.

variable "regions" {
  default = ["us-east-1", "us-west-2"]
}

provider "aws" {
  alias  = each.value
  region = each.value
  for_each = toset(var.regions)
}

resource "aws_instance" "multi_region" {
  provider = aws[each.key]
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = length(var.regions)

  tags = {
    Name = "MultiRegionInstance-${each.key}"
  }
}
