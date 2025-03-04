# Google Cloud Workstation image pipeline manual update

## Deploy

- Apply the `initialize` Terraservice.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform/initialize && \
  rm -rf .terraform/ && \
  terraform init && \
  terraform plan -input=false -out=tfplan && \
  terraform apply -input=false tfplan && \
  rm tfplan
  ```

- Load the environment variables from the Terraform configuration.

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

- Commit changes to the repository.

  ```
  cd ${GCCWSI_REPO_ROOT}/terraform
  git add *
  git commit -m "Updated the repository"
  git push
  ```
