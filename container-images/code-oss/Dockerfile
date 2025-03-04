ARG AR_PROJECT_ID
ARG AR_LOCATION

FROM ${AR_LOCATION}-docker.pkg.dev/${AR_PROJECT_ID}/cloud-workstations-images-upstream/code-oss:latest

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && \
apt-get -y upgrade && \
apt-get install -y \
build-essential \
gettext-base \
libffi-dev \
libz-dev \
libbz2-dev \
liblzma-dev \
libncursesw5-dev \
libreadline-dev \
libsqlite3-dev \
libssl-dev \
moreutils
