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

# Create the build service account
resource "google_service_account" "cloud_workstation_image_build" {
  account_id   = "cloud-workstation-image-build"
  description  = "Terraform-managed service account for gc-cloud-workstation-image build"
  display_name = "gc-cloud-workstation-image build service account"
  project      = data.google_project.default.project_id
}

# Create the Terraform service account
resource "google_service_account" "cloud_workstation_image_terraform" {
  account_id   = "cloud-workstation-image-terraform"
  display_name = "Terraform-managed service account for gc-cloud-workstation-image Terraform"
  description  = "gc-cloud-workstation-image Terraform service account"
  project      = data.google_project.default.project_id
}
