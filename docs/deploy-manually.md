# Google Cloud Workstation image pipeline manual deployment

## Deploy

- Apply the `initialize` Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/initialize && \
  rm -rf .terraform/ backend.tf && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply -input=false tfplan && \
  rm tfplan
  ```

- Migrate the `initialize` Terraservice backend to the GCS bucket.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/initialize && \
  terraform init -force-copy -migrate-state && \
  rm -rf terraform.tfstate*
  ```

- Commit changes to the repository.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform
  git add *
  git commit -m "Initialized repository"
  git push
  ```

- Load environment variables from terraform configuration.

  ```
  source ${GCCWSI_REPO_ROOT}/terraform/_shared_config/scripts/set_environment_variables.sh
  ```

- Apply the Git Provider Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/${git_provider} && \
  rm -rf .terraform/ && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply -input=false tfplan && \
  rm tfplan
  ```

- Apply the `cloudbuild` Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/cloudbuild && \
  rm -rf .terraform/ && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply -input=false tfplan && \
  rm tfplan
  ```

- Create the upstream Artifact Registry repository.

  With the Google Terraform provider, Artifact Registry repositories are not
  supported as custom remote repository URI.

  ```
  gcloud artifacts repositories create cloud-workstations-images-upstream \
  --allow-vulnerability-scanning \
  --description="Upstream cloud-workstations-images remote repository" \
  --location=${region} \
  --mode=remote-repository \
  --project=${project_id} \
  --remote-docker-repo="https://us-west1-docker.pkg.dev/cloud-workstations-images/predefined" \
  --repository-format="DOCKER"
  ```

<!--
- Import the upstream repository.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/cloudbuild && \
  terraform init && \
  terraform import google_artifact_registry_repository.cloud_workstations_images_upstream projects/${project_id}/locations/${region}/repositories/cloud-workstations-images-upstream
  ```
-->

- Build `code-oss` workstation image.

  ```
  export CODE_OSS_IMAGE="${region}-docker.pkg.dev/${project_id}/cloud-workstations-images/code-oss:latest"

  cd ${GCCWSI_REPO_ROOT}/container-images/code-oss
  docker build \
  --build-arg AR_PROJECT_ID=${project_id} \
  --build-arg AR_LOCATION=${region} \
  --tag ${CODE_OSS_IMAGE} \
  . && \
  docker push ${CODE_OSS_IMAGE}
  ```
