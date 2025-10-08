###########################################################################################################
#
# How to build:
#
# docker build -t arkcase/deploy-base:latest .
#
###########################################################################################################

#
# Basic Parameters
#
ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="2.0.0"

ARG BASE_REGISTRY="${PUBLIC_REGISTRY}"
ARG BASE_REPO="arkcase/base-java"
ARG BASE_VER="22.04"
ARG BASE_VER_PFX=""
ARG BASE_IMG="${BASE_REGISTRY}/${BASE_REPO}:${BASE_VER_PFX}${BASE_VER}"

FROM "${BASE_IMG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer Image" \
      VERSION="${VER}"

#
# Environment variables
#
ENV INIT_DIR="${BASE_DIR}/init"
ENV DEPL_DIR="${BASE_DIR}/depl"
ENV VER="${VER}"

#
# We add all of this crap b/c it may come in handy later and it doesn't
# weigh enough to be of true concern
#
RUN apt-get -y install \
        git \
        patch \
      && \
    apt-get clean

COPY --chown=root:root --chmod=0555 entrypoint /
COPY --chown=root:root --chmod=0555 scripts/* /usr/local/bin/

ENV DEPL_URL="https://app-artifacts"

USER root
WORKDIR "${DEPL_DIR}"
ENTRYPOINT [ "/entrypoint" ]
