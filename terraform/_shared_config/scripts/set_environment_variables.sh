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

set -o allexport
set -o errexit
set -o nounset
set -o pipefail

SHARED_CONFIG_PATH="${GCCWSI_REPO_ROOT}/terraform/_shared_config"

echo "Loading shared configuration(${SHARED_CONFIG_PATH})"
echo "-------------------------------------------------------------------------"
cd "${SHARED_CONFIG_PATH}" || exit 1
rm -f terraform.tfstate*
terraform init >/dev/null
terraform apply -auto-approve -input=false >/dev/null
terraform output
echo "-------------------------------------------------------------------------"
eval "$(terraform output | sed -r 's/(\".*\")|\s*/\1/g')"
rm -f terraform.tfstate*
cd - >/dev/null

set +o allexport
set +o errexit
set +o nounset
set +o pipefail
