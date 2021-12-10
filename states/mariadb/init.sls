mariadb:
  pkg.installed:
    - pkgs:
      - mariadb-client
      - mariadb-server
    - reload_modules: True

/tmp/create_user.sql:
  file.managed:
    - mode: 600
    - source: salt://mariadb/createcommands.sql

'cat /tmp/create_user.sql | sudo mariadb':
  cmd.run:
    - unless: "echo 'show databases' | sudo mariadb | grep '^koira$'"

#/home/vagrant/.my.cnf:
#  file.managed:
#    - source: salt://mariadb/.my.cnf
#    - replace: False
#    - user: vagrant
#    - group: vagrant


#Not necessary in newer version
