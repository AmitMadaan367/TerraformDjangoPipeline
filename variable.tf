variable "cidr_block" {
  type = string
  default="10.0.1.0/24"
}

variable "cidr_block2" {
  type = string
  default = "10.0.2.0/24"
}

variable "resource_tag_name" {
  description = "Resource tag name for cost tracking"
  type = string
  default = "Source"
}

variable "category" {
  description = "AWS resource category"
  type = string
  default = "Source"
}

variable "owner" {
  description = "ThirdParty"
  type = string
  default = "ThirdParty"
}



variable "github_token" {
  type        = string
  description = "Github OAuth token"
   default     = ""
}

variable "github_repo" {
  type        = string
  description = "Github repo"
   default     = "textpro"
}


variable "github_owner" {
  type        = string
  description = "Github username"
  default     = "AmitMadaan367"
}


variable "branch" {
  type        = string
  description = "branch name"
  default="main"
}





variable "service_name" {
  default = "Django"
}


variable "app_name" {
type    = string
  default = "new"
}