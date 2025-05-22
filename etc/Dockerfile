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

COPY bin/functions.sh ${BIN_DIR}/
COPY bin/run.sh ${BIN_DIR}/
COPY etc/banner.txt ${ETC_DIR}/

# Add the default user.
RUN adduser -D ${USER_ID}

USER ${USER_ID}

# Creates the required directories.
RUN mkdir -p ${BIN_DIR} ${ETC_DIR}

# Sets the default work directory.
WORKDIR ${HOME_DIR}

# Default entrypoint.
CMD [ "linode-cli", "--help" ]