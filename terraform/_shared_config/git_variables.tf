# Copyright 2025 Aaron Rueth <aaron@rueth.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  git_repository_id = "projects/${var.project_id}/locations/${var.region}/connections/gc-cloud-workstation-image/repositories/gc-cloud-workstation-image"
}

variable "git_gh_cb_app_installation_id" {
  default     = null
  description = "The app installation ID for the Cloud Build GitHub App"
  type        = string
}

variable "git_namespace" {
  description = "The Git repository namespace."
  type        = string

  validation {
    condition     = var.git_namespace != ""
    error_message = "'git_namespace' was not set, please set the TF_VAR_git_namespace environment variable or set the value in the git.auto.tfvars file."
  }
}

variable "git_provider" {
  description = "The Git provider for the repository."
  type        = string

  validation {
    condition     = contains(["github.com"], var.git_provider)
    error_message = "'git_provider' was set to an unsupported provider, available providers are [ github.com ]"
  }
}

variable "git_repository" {
  description = "The Git repository name."
  type        = string

  validation {
    condition     = var.git_repository != ""
    error_message = "'git_repository' was not set, please set the TF_VAR_git_repository environment variable or set the value in the git.auto.tfvars file."
  }
}

variable "git_token_file" {
  description = "The full path to the Git token."
  type        = string

  validation {
    condition     = var.git_token_file != ""
    error_message = "'git_token_file' was not set, please set the TF_VAR_git_token_file environment variable or set the value in the git.auto.tfvars file."
  }
}
