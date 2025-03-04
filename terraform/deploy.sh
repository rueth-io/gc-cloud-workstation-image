#!/usr/bin/env bash
#
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

set -o errexit
set -o nounset
set -o pipefail

source ${GCCWSI_REPO_ROOT}/terraform/_shared_config/scripts/set_environment_variables.sh

if gcloud storage ls "gs://${gcs_bucket_name}/terraform/initialize/default.tfstate" &>/dev/null; then
  echo
  echo "It appears that the initial deployment of the pipeline was already run."
  echo "Use the '\${GCCWSI_REPO_ROOT}/terraform/apply.sh' script to apply any changes."
  echo
  exit 1
fi

cd ${GCCWSI_REPO_ROOT}/terraform/initialize &&
  rm -rf .terraform/ backend.tf &&
  terraform init &&
  terraform plan -input=false -out=tfplan &&
  terraform apply -input=false tfplan &&
  rm tfplan

cd ${GCCWSI_REPO_ROOT}/terraform/initialize &&
  terraform init -force-copy -migrate-state &&
  rm -rf terraform.tfstate*

cd ${GCCWSI_REPO_ROOT}/terraform/${git_provider} &&
  rm -rf .terraform/ &&
  terraform init &&
  terraform plan -input=false -out=tfplan &&
  terraform apply -input=false tfplan &&
  rm tfplan

cd ${GCCWSI_REPO_ROOT}/terraform/cloudbuild &&
  rm -rf .terraform/ &&
  terraform init &&
  terraform plan -input=false -out=tfplan &&
  terraform apply -input=false tfplan &&
  rm tfplan

gcloud artifacts repositories create cloud-workstations-images-upstream \
  --allow-vulnerability-scanning \
  --description="Upstream cloud-workstations-images remote repository" \
  --location=${region} \
  --mode=remote-repository \
  --project=${project_id} \
  --remote-docker-repo="https://us-west1-docker.pkg.dev/cloud-workstations-images/predefined" \
  --repository-format="DOCKER"

cd ${GCCWSI_REPO_ROOT}/terraform &&
  git add * &&
  git commit -m "Initialized repository" &&
  git push
