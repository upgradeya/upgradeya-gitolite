FROM debian:jessie
MAINTAINER David Parrish <daveparrish@tutanota.com>

# Update Debian.
# install requirements (duply, mariadb-client, ssh)
RUN apt-get -y update && \
apt-get install -y -q --no-install-recommends \
  ca-certificates \
  duply \
  mariadb-client \
  openssh-client \
  python-paramiko \
  dateutils \
&& apt-get clean \
&& rm -r /var/lib/apt/lists/*

# Create user to run backups
RUN useradd -m -s /bin/bash duply

# Copy duply profiles
COPY .duply/ /root/.duply
# Copy ssh keys
COPY .ssh/ /root/.ssh

# Add GPG keys for encrypting config tars
COPY public_keys /root/public_keys
COPY load_developer_keys /root/
RUN chmod a+rx /root/load_developer_keys

# Setup volumes for backup
RUN install -dm777 /root/backup && \
  install -dm777 /root/{{PROJECT_BACKUP_CONFIG_BACKUP_DIRECTORY}} && \
  install -dm777 /root/.cache/duplicity
VOLUME /root/backup
VOLUME /root/{{PROJECT_BACKUP_CONFIG_BACKUP_DIRECTORY}}
VOLUME /root/.cache/duplicity

# Build site
WORKDIR /root

# Load the public keys into key chain for encrypting config tars
RUN ./load_developer_keys

# Copy backup service script
COPY backup_service /root/backup_service

# Run backup service script by default
CMD /root/backup_service
