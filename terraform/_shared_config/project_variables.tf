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

variable "gcs_bucket_name" {
  description = "The Google Cloud Storage bucket to use for the cloud workstation images."
  type        = string

  validation {
    condition     = var.gcs_bucket_name != ""
    error_message = "'gcs_bucket_name' was not set, please set the TF_VAR_gcs_bucket_name environment variable or set the value in the project.auto.tfvars file."
  }
}

variable "project_id" {
  description = "The Google Cloud project where the cloud workstation images with be deployed."
  type        = string

  validation {
    condition     = var.project_id != ""
    error_message = "'project_id' was not set, please set the TF_VAR_project_id environment variable or set the value in the project.auto.tfvars file."
  }
}

variable "region" {
  description = "The Google Cloud region where the cloud workstation images with be deployed."
  type        = string

  validation {
    condition     = var.region != ""
    error_message = "'region' was not set, please set the TF_VAR_region environment variable or set the value in the project.auto.tfvars file."
  }
}
