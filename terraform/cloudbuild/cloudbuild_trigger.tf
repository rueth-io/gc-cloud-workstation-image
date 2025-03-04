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

resource "google_cloudbuild_trigger" "terraform_apply" {
  filename = "ci-cd/cloudbuild/terraform-apply.yaml"
  ignored_files = [
    "terraform/deploy.sh",
    "terraform/teardown.sh",
  ]
  included_files = [
    "ci-cd/cloudbuild/terraform-apply.yaml",
    "terraform/**",
  ]
  location        = var.region
  name            = "terraform-apply"
  project         = data.google_project.default.project_id
  service_account = google_service_account.cloud_workstation_image_terraform.id

  repository_event_config {
    repository = local.git_repository_id

    push {
      branch       = "^main$"
      invert_regex = false
    }
  }
}
