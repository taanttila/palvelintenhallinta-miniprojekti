Default programs:
  pkg.installed:
    - pkgs:
      - curl
      - ssh
      - apache2
      - mariadb-server
      - mariadb-client
      - php
      - libapache2-mod-php
      - php-mysql
      - git


mariadb:
  service.running:
    - enable: True


