FROM alpine:3.9

ENV CLOUD_SDK_VERSION="297.0.1"

RUN apk add --no-cache \
    bash \
    curl \
    git \
    gnupg \
    libc6-compat \
    mysql-client \
    openssh-client \
    py3-crcmod \
    python3

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

ENTRYPOINT ["crond", "-f"]