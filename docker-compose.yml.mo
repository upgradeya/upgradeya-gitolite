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

# vi: set tabstop=2 expandtab syntax=yaml:
