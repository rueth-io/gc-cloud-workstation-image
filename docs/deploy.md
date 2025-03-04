# Deploy the Google Cloud Workstation image pipeline

## Prerequisites

- A fork version of this repository.
- A configured host connection for your Git provider.
- A Git provider token.

### Git provider token

#### GitHub

A GitHub
[personal access token (classic)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-tokens-classic)
is needed to authorize the
[Google Cloud Build GitHub App](https://github.com/apps/google-cloud-build)
connection. Steps to generate a personal access token (classic) are available at
[Creating a personal access token (classic)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).
At the time this was implemented,
[fine-grained personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#fine-grained-personal-access-tokens)
were not yet fully supported.

- Generate a personal access tokens (classic) with the following permissions:

  | Scope     |
  | --------- |
  | repo      |
  | read:user |
  | read:org  |

- Store the token in a secure file.

  ```
  # Create a secure directory
  mkdir -p ${HOME}/secrets/
  chmod go-rwx ${HOME}/secrets

  # Create a secure file
  touch ${HOME}/secrets/gccwsi-github-token
  chmod go-rwx ${HOME}/secrets/gccwsi-github-token

  # Put the token in the secure file using nano or your preferred editor
  nano ${HOME}/secrets/gccwsi-github-token
  ```

<!--
#### GitLab

**TODO: Add information about generating tokens.**

- Store the token in a secure file.

  ```
  # Create a secure directory
  mkdir -p ${HOME}/secrets/
  chmod go-rwx ${HOME}/secrets

  # Create a secure file
  touch ${HOME}/secrets/gccwsi-gitlab-token
  chmod go-rwx ${HOME}/secrets/gccwsi-gitlab-token

  # Put the token in the secure file using nano or your preferred editor
  nano ${HOME}/secrets/gccwsi-gitlab-token
  ```
-->

## Configure the environment

### Environment variables.

- The forked Git repository's provider, currently the only option is
  "github.com"

  ```
  export TF_VAR_git_provider="github.com"
  ```

- The forked Git repository's organization or user namespace.

  ```
  export TF_VAR_git_namespace=
  ```

- The forked Git repository's name.

  ```
  export TF_VAR_git_repository=
  ```

- TThe full path to the Git token for the forked.

  ```
  export TF_VAR_git_token_file="${HOME}/secrets/gccwsi-github-token"
  ```

- The Google Cloud project ID.

  ```
  export TF_VAR_project_id=
  ```

- The Google Cloud region.

  ```
  export TF_VAR_region=
  ```

- The Google Cloud Storage bucket name.

  ```
  export TF_VAR_gcs_bucket_name="${TF_VAR_project_id}-gc-cloud-workstation-image"
  ```

- The local path where the repository will reside.

  ```
  export GCCWSI_REPO_ROOT="${HOME}/gc-cloud-workstation-image" && \
  echo "export GCCWSI_REPO_ROOT=${GCCWSI_REPO_ROOT} >> ${HOME}./profile"
  ```

### Git provider host connection

Only one of the following Git provider host connections should be configured.

#### GitHub

- Initiate a connection to your GitHub repository.

  ```
  gcloud builds connections create github gh-gc-cloud-workstation-image \
  --project=${TF_VAR_project_id} \
  --region=${TF_VAR_region}
  ```

  After running the gcloud builds connections command, you will see a link to
  authorize the Cloud Build GitHub App.

- Follow the link to authorize the Cloud Build GitHub App.

- Install the Cloud Build GitHub App in your user namespace or in the
  organization for the repository. Permit the installation using the selected
  GitHub account.

- Verify the installation of your GitHub connection.

  ```
  gcloud builds connections describe gh-gc-cloud-workstation-image \
  --project=${TF_VAR_project_id} \
  --region=${TF_VAR_region}
  ```

  The output should be similar to:

  ```
  createTime: 'YYYY-MM-DDTHH:MM:SS.ZZZZZZZZZZ'

  etag: XXXXXXXXXXXXXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXX
  githubConfig:
    appInstallationId: '########'
    authorizerCredential:
      oauthTokenSecretVersion: projects/<project_id>/secrets/gh-gc-cloud-workstation-image-github-oauthtoken-XXXXXX/versions/latest
      username: XXXXXXXXXX
  installationState:
    stage: COMPLETE
  name: projects/<project_id>/locations/<region>/connections/gh-gc-cloud-workstation-image
  reconciling: false
  updateTime: 'YYYY-MM-DDTHH:MM:SS.ZZZZZZZZZZ'
  ```

- Get the appInstallationId for the Cloud Build GitHub App.

  ```
  export TF_VAR_git_gh_cb_app_installation_id=$(gcloud builds connections describe gh-gc-cloud-workstation-image \
  --project=${TF_VAR_project_id} \
  --region=${TF_VAR_region} \
  --format="value(githubConfig.appInstallationId)") && \
  echo -e "\nTF_VAR_git_gh_cb_app_installation_id=${TF_VAR_git_gh_cb_app_installation_id}"
  ```

For additional information see the
[Connecting a GitHub host](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen#connecting_a_github_host)
part of the
[Connect to a GitHub repository](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github?generation=2nd-gen)
document.

<!--
#### GitLab

**TODO: Add information setting up connection**

- Initiate a connection to your GitLab repository.

  ```
  gcloud builds connections create gitlab gh-gc-cloud-workstation-image \
  --authorizer-token-secret-version=AUTHORIZER_TOKEN_SECRET_VERSION \
  --project=${TF_VAR_project_id} \
  --read-authorizer-token-secret-version=READ_AUTHORIZER_TOKEN_SECRET_VERSION \
  --region=${TF_VAR_region} \
  --webhook-secret-secret-version=WEBHOOK_SECRET_SECRET_VERSION
  ```

  After running the gcloud builds connections command, you will see a link to
  authorize the Cloud Build GitHub App.

- Follow the link to authorize the Cloud Build GitHub App.

- Install the Cloud Build GitHub App in your user namespace or in the
  organization for the repository. Permit the installation using the selected
  GitHub account.

- Verify the installation of your GitHub connection.

  ```
  gcloud builds connections describe gh-gc-cloud-workstation-image \
  --project=${TF_VAR_project_id} \
  --region=${TF_VAR_region}
  ```

For additional information see the
[Connect to a GitLab host](https://cloud.google.com/build/docs/automating-builds/gitlab/connect-host-gitlab)
document.
-->

### Repository

- Clone your forked repository.

  ```
  git clone https://${TF_VAR_git_provider}/${TF_VAR_git_namespace}/${TF_VAR_git_repository}.git ${GCCWSI_REPO_ROOT} && \
  cd ${GCCWSI_REPO_ROOT}
  ```

## Deploy

- Run the provided `deploy.sh` script.

  ```
  ${GCCWSI_REPO_ROOT}/terraform/deploy.sh
  ```

  To run through the deployment manually step by step, see
  [Google Cloud Workstation image pipeline manual deployment](/docs/deploy-manually.md)

## Teardown

To teardown the pipeline, see
[Teardown the Google Cloud Workstation image pipeline](/docs/teardown.md)
