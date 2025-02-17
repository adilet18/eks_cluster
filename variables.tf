
variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project = "Final"
    env     = "Prod"
  }
}
