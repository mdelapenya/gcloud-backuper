FROM alpine:3.9

ARG OS_ARCHITECTURE="x86_64"
ARG TZ='Europe/Madrid'

ENV CLOUD_SDK_VERSION="297.0.1"
ENV DEFAULT_TZ ${TZ}
ENV PATH="/google-cloud-sdk/bin:$PATH"

RUN apk add --no-cache \
    bash \
    curl \
    git \
    gnupg \
    libc6-compat \
    mysql-client \
    openssh-client \
    py3-crcmod \
    python3 \
    tzdata

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${OS_ARCHITECTURE}.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${OS_ARCHITECTURE}.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-${OS_ARCHITECTURE}.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime

ENTRYPOINT ["crond", "-f"]
