variable "flux_ssh_scan_url" {
  description = "The SSH Key scan"
  type        = string

  default = "github.com"
}

variable "git_url" {
  description = "The URL of the git repository"
  type        = string

  default = "ssh://git@github.com/kube-champ/josa-demo.git"
}

variable "flux_target_path" {
  description = "The path of the directory in the Git repository on which Flux will sync"
  type        = string

  default = "flux/clusters/josa"
}