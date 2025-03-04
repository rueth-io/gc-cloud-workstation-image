# Teardown the Google Cloud Workstation image pipeline

## Prerequisites

- The `GCCWSI_REPO_ROOT` environment variable set.
- The root of the repository is available at `${GCCWSI_REPO_ROOT}`.

## Teardown

- Run the provided `teardown.sh` script.

  ```
  ${GCCWSI_REPO_ROOT}/terraform/teardown.sh
  ```

  To run through the teardown manually step by step, see
  [Google Cloud Workstation image pipeline manual teardown](/docs/teardown-manually.md)
