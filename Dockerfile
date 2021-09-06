FROM ubuntu As builder
RUN apt-get update &&\
    apt-get install -y git &&\
    git clone https://github.com/toniblyx/prowler
FROM openjdk:8-jdk-alpine
ARG USERNAME=prowler
ARG USERID=34000
RUN addgroup -g ${USERID} ${USERNAME} && \
    adduser -s /bin/sh -G ${USERNAME} -D -u ${USERID} ${USERNAME} && \
    apk --update --no-cache add python3 bash curl jq file coreutils py3-pip && \
    pip3 install --upgrade pip && \
    pip3 install awscli boto3 detect-secrets
COPY . ./
WORKDIR /prowler
RUN chown -R prowler .
RUN chmod +x ./prowler
USER ${USERNAME}
ENTRYPOINT ["./prowler"]
