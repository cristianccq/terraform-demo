# URL Local Registry
variable "local_registry_url" {    
    type    = string
    default = "192.168.21.78:5000"
}

variable "list_local_repos" {
  type    = list(string)
  default = ["avb_hdi_image_actions:latest","avb_hdi_image_core_nlu:latest","duckling:latest"]  #["busybox:latest", "hello-world:latest"]
}

variable "aws_region" {    
    type    = string
    default = "us-east-1"
}

variable "aws_account_id" {    
    type    = string
    default = "894268508623"
}