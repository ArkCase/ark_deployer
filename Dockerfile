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
ARG BASE_REPO="arkcase/base"
ARG BASE_TAG="8.7.0"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.0.2"
ARG BLD="01"

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG BLD
ARG BASE_DIR="/app"
ARG INIT_DIR="${BASE_DIR}/init"
ARG DEPL_DIR="${BASE_DIR}/depl"

LABEL ORG="ArkCase LLC" \
      MAINTAINER="Armedia Devops Team <devops@armedia.com>" \
      APP="ArkCase Deployer Image" \
      VERSION="${VER}-${BLD}"

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
RUN yum -y update && \
    yum -y install \
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
    "list-artifacts" \
    "list-categories" \
    "deploy-artifact" \
    "/usr/local/bin/"
RUN chmod a=rx \
        "/usr/local/bin/wait-for-artifacts" \
        "/usr/local/bin/list-artifacts" \
        "/usr/local/bin/list-categories" \
        "/usr/local/bin/deploy-artifact"

USER root
WORKDIR "${DEPL_DIR}"
ENTRYPOINT [ "/deploy" ]
