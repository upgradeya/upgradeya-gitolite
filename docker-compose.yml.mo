gitolite:
  image: 'jgiannuzzi/gitolite'
{{#PROJECT_PRODUCTION}} 
  restart: always
{{/PROJECT_PRODUCTION}} 
  ports:
    - '{{PROJECT_SSH_PORT}}:22'
  volumes:
    - '{{PROJECT_NAMESPACE}}_home:/home/git/repositories'
    - '{{PROJECT_NAMESPACE}}_ssh:/etc/ssh'
  environment:
    SSH_KEY: '{{PROJECT_GITOLITE_ADMIN_SSH_KEY}}'
    SSH_KEY_NAME: '{{PROJECT_SSH_KEY_NAME}}'
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
# Backup
backup:
  build: containers/backup/.
  command: "/root/backup_service"
  volumes_from:
    - gitolite
  log_driver: {{PROJECT_DOCKER_LOG_DRIVER}}
{{#PRODUCTION}}
  restart: always
{{/PRODUCTION}}

# vi: set tabstop=2 expandtab syntax=yaml:
