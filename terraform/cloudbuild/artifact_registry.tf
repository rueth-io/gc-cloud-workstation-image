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

resource "google_artifact_registry_repository" "ci_cd" {
  description   = "CI/CD images"
  format        = "DOCKER"
  location      = var.region
  project       = data.google_project.default.project_id
  repository_id = "ci-cd"

  cleanup_policies {
    action = "DELETE"
    id     = "Delete untagged images"

    condition {
      tag_state = "UNTAGGED"
    }
  }
}

resource "google_artifact_registry_repository" "cloud_workstations_images" {
  description   = "Cloud workstations images"
  format        = "docker"
  location      = var.region
  project       = data.google_project.default.project_id
  repository_id = "cloud-workstations-images"

  cleanup_policies {
    action = "DELETE"
    id     = "Delete untagged images"

    condition {
      tag_state = "UNTAGGED"
    }
  }

  cleanup_policies {
    action = "KEEP"
    id     = "Keep 7 most recent versions"

    most_recent_versions {
      keep_count = 7
    }
  }
}

# With the Google Terraform provider, Artifact Registry repositories are not supported as custom remote repository URI.
# resource "google_artifact_registry_repository" "cloud_workstations_images_upstream" {
#   description   = "Upstream cloud-workstations-images remote repository"
#   format        = "docker"
#   location      = var.region
#   mode          = "REMOTE_REPOSITORY"
#   project       =  data.google_project.default.project_id
#   repository_id = "cloud-workstations-images-upstream"

#   remote_repository_config {
#     docker_repository {
#       custom_repository {
#         uri = "https://us-west1-docker.pkg.dev/cloud-workstations-images/predefined"
#       }
#     }
#   }
# }
