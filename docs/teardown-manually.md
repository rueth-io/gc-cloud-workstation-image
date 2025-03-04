# Google Cloud Workstation image pipeline manual teardown

## Teardown

- Load the environment variables from the Terraform configuration.

  ```
  source ${GCCWSI_REPO_ROOT}/terraform/_shared_config/scripts/set_environment_variables.sh
  ```

- Destroy the upstream Artifact Registry repository.

  ```
  gcloud artifacts repositories delete cloud-workstations-images-upstream \
  --location=${region} \
  --project=${project_id} \
  --quiet
  ```

- Destroy the `cloudbuild` Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/cloudbuild
  rm -rf .terraform/ && \
  terraform init && \
  terraform destroy -auto-approve
  ```

- Destroy the Git Provider Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/${git_provider}
  rm -rf .terraform/ && \
  terraform init && \
  terraform destroy -auto-approve
  ```

- Destroy the the `initialize` Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/initialize && \
  rm -rf .terraform/ && \
  terraform init && \
  rm -rf backend.tf && \
  terraform init -force-copy -lock=false -migrate-state && \
  gcloud storage rm -r "gs://${gcs_bucket_name}/*" && \
  terraform destroy -auto-approve
  ```
