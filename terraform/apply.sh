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

cd ${GCCWSI_REPO_ROOT}/terraform/initialize &&
  rm -rf .terraform/ &&
  terraform init &&
  terraform plan -input=false -out=tfplan &&
  terraform apply -input=false tfplan &&
  rm tfplan

source ${GCCWSI_REPO_ROOT}/terraform/_shared_config/scripts/set_environment_variables.sh

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
