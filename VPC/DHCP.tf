resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name          = "wsi-dhcp"
  domain_name_servers  = ["10.0.0.2"]
  ntp_servers          = ["169.254.169.123"]
  netbios_node_type    = 2

  tags = {
    Name = "wsi-dhcp"
  }
}