#variable "image_id" {
#    default = "ami-09c813fb71547fc4f"
#    type = string
#}
 
variable "common_tags" {
    default = {
        project = "expense"
        Terraform = "true"
        environment = "dev"
    }
}

variable "zone_name" {
    type = string
    default = "daws78s.online"
}


#variable "zone_id" {
#    type = string                                                      # zone_id is hosted zone there it is available
#    default = "Z03688782L8GUNVYZSFY0"
#}