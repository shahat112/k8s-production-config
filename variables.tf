variable "cloud_id" {
  type    = string
  default = "b1gvg8agfq4ed4sgn4l8"
}

variable "folder_id" {
  type    = string
  default = "b1g7jdj5bipad92pm2ot"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_token" {
  type      = string
  sensitive = true
}
