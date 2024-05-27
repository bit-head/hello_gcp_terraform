variable "location" {
  description = "GEO Location of your deployment"
  type        = string
  default     = "us-west1-a"
}

variable "google_creds" {
  description = "path to your google credentials.json"
  type        = string
}