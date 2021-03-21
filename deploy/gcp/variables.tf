# gcp credentials
variable "authkey" {
  description = "credential JSON filename for authentication"
  type        = string
}

variable "gcp_project_id" {
  description = "gcp project identifier for deployment"
  type        = string
}

# domain name and associated data
variable "domain" {
  description = "the domain name of the website"
  type        = string
}

# the dist configuration containing production files
variable "dist_path" {
  type        = string
  description = "the path of the dist folder containing the bundled files for the website"
  default     = "/dist/"
}
