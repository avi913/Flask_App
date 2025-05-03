variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "project_1"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}


variable "acr_name" {
  default = "flaskacr5002" # Must be globally unique
}

variable "aks_name" {
  default = "flask-aks"
}
