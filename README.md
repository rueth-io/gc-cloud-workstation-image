# gc-cloud-workstation-image

This repository contains the infrastructure as code (IaC) and examples CI/CD
pipelines needed to build images for Google Cloud
[Cloud Workstation](https://cloud.google.com/workstations).

## What are Cloud Workstations?

Cloud Workstations provide managed, pre-configured, and on-demand development
environments that run directly in your Google Cloud project. They simplify the
setup and maintenance of developer tools, allowing you to focus on coding.

While Google Cloud maintains several
[preconfigured base images](https://cloud.google.com/workstations/docs/preconfigured-base-images)
designed for use with Cloud Workstations, you might need to:

- **Customize Your Environment:** Install specific tools, SDKs, libraries, or
  dependencies required for your projects.
- **Automate Configuration:** Pre-configure settings, themes, or extensions for
  a consistent development experience across your team.
- **Enforce Security Standards:** Ensure all images have necessary security
  patches and compliance configurations.
- **Use specific versions:** Base images are updated regularly, but your team
  might be blocked on using a specific version of tools.

This repository allows you to create
[**custom container images**](https://cloud.google.com/workstations/docs/customize-container-images)
that extend the functionality of base images or build new ones completely from
scratch. These custom images can then be deployed in your Cloud Workstation
configurations.

## Getting Started

1.  **Prerequisites:** Ensure you have a Google Cloud project and have the
    necessary permissions to manage Cloud Build, Artifact Registry, and other
    relevant resources.
1.  **Repository structure**: Check the
    [Repository structure](/docs/repository-structure.md) to understand the
    different folders.
1.  **Architecture overview**: Explore the [Architecture](/docs/architecture.md)
    to learn about the design and components.
1.  **Deployment:** Follow the guide on how to
    [Deploy the Google Cloud Workstation image pipeline](/docs/deploy.md) to set
    up your own CI/CD pipelines.
