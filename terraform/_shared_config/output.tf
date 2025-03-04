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

output "gcs_bucket_name" {
  value = var.gcs_bucket_name
}

output "git_gh_cb_app_installation_id" {
  value = var.git_gh_cb_app_installation_id
}

output "git_namespace" {
  value = var.git_namespace
}

output "git_provider" {
  value = var.git_provider
}

output "git_repository" {
  value = var.git_repository
}

output "git_token_file" {
  value = var.git_token_file
}

output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}
