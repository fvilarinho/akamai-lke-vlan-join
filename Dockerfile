# Base image.
FROM alpine:latest

# Update and install required packages.
RUN apk update && \
    apk add --no-cache bash \
                       net-tools \
                       bind-tools \
                       python3 \
                       py3-pip \
                       jq

# Set up the python environment to install/allow the Linode CLI.
RUN python3 -m venv /opt/venv && \
            . /opt/venv/bin/activate && \
            pip3 install --upgrade pip && \
            pip3 install --upgrade linode-cli

# Required environment variables.
ENV USER_ID=akamai-lke-vlan-join
ENV HOME_DIR=/home/${USER_ID}
ENV BIN_DIR=${HOME_DIR}/bin
ENV ETC_DIR=${HOME_DIR}/etc
ENV PATH="/opt/venv/bin:$PATH"

RUN addgroup -S ${USER_ID} && \
    adduser -S ${USER_ID} -G ${USER_ID} && \
    mkdir -p ${BIN_DIR} ${ETC_DIR} && \
    chown -R ${USER_ID}:${USER_ID} ${HOME_DIR}

USER ${USER_ID}

# Creates the required directories.
COPY bin/functions.sh ${BIN_DIR}/
COPY bin/run.sh ${BIN_DIR}/
COPY etc/banner.txt ${ETC_DIR}/

RUN chmod +x ${BIN_DIR}/*.sh && \
    ln -s ${BIN_DIR}/run.sh /entrypoint.sh

# Sets the default work directory.
WORKDIR ${HOME_DIR}

# Default entrypoint.
ENTRYPOINT [ "/entrypoint.sh" ]