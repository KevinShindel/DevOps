#------------------------------
#
#
# Created by Kevin Shindel
#------------------------------

output "web_load_balancer_url" {
  value = aws_elb.this.dns_name
}