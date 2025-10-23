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
ARG VER="1.5.0"

ARG BASE_REGISTRY="${PUBLIC_REGISTRY}"
ARG BASE_REPO="arkcase/base"
ARG BASE_VER="8"
ARG BASE_VER_PFX=""
ARG BASE_IMG="${BASE_REGISTRY}/${BASE_REPO}:${BASE_VER_PFX}${BASE_VER}"

FROM "${BASE_IMG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG BASE_DIR="/app"
ARG INIT_DIR="${BASE_DIR}/init"
ARG DEPL_DIR="${BASE_DIR}/depl"

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer Image" \
      VERSION="${VER}"

#
# Environment variables
#
ENV JAVA_HOME="/usr/lib/jvm/java" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    BASE_DIR="${BASE_DIR}" \ 
    INIT_DIR="${INIT_DIR}" \
    DEPL_DIR="${DEPL_DIR}" \
    VER="${VER}"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

#################
# Prepare the base environment
#################
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

#
# We add all of this crap b/c it may come in handy later and it doesn't
# weigh enough to be of true concern
#
RUN yum -y install \
        epel-release && \
    yum -y install \
        java-11-openjdk-devel \
        git \
        jq \
        openssl \
        patch \
        python3-pyyaml \
        python3-pip \
        unzip \
        wget \
        xmlstarlet \
        zip \
    && \
    yum -y clean all && \
    update-alternatives --set python /usr/bin/python3 && \
    pip3 install openpyxl && \
    rm -rf /tmp/*

COPY --chown=root:root \
    "wait-for-artifacts" \
    "list-elements" \
    "list-artifacts" \
    "list-categories" \
    "entrypoint" \
    "deploy-artifact" \
    "get-global-sums" \
    "/usr/local/bin/"
RUN chmod a=rx \
        "/usr/local/bin/wait-for-artifacts" \
        "/usr/local/bin/list-elements" \
        "/usr/local/bin/list-artifacts" \
        "/usr/local/bin/list-categories" \
        "/usr/local/bin/entrypoint" \
        "/usr/local/bin/deploy-artifact" \
        "/usr/local/bin/get-global-sums"

ENV DEPL_URL="https://app-artifacts"

USER root
WORKDIR "${DEPL_DIR}"
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
