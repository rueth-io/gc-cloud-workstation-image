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

# When implemented, only google_secret_manager_secret was supported for 
# google_cloudbuildv2_connection.github_config.oauth_token_secret_version 
# and not google_secret_manager_regional_secret.
resource "google_secret_manager_secret" "git_token_images" {
  project   = google_project_service.secretmanager_googleapis_com.project
  secret_id = "git-token-images"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "git_token_images_latest" {
  secret      = google_secret_manager_secret.git_token_images.id
  secret_data = file(var.git_token_file)
}

resource "google_secret_manager_secret_iam_member" "cloudbuild_secretmanager_secret_accessor" {
  member    = "serviceAccount:service-${data.google_project.default.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  project   = data.google_project.default.project_id
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.git_token_images.secret_id
}
