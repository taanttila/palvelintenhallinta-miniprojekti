/etc/apache2/mods-enabled/dir.conf:
  file.managed:
    - source: salt://apache/dir.conf

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: /etc/apache2/mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: /etc/apache2/mods-available/userdir.load

/etc/apache2/mods-available/php7.4.conf:
  file.managed:
    - source: salt://apache/php7.4.conf

apache2service:
  service.running:
    - name: apache2   
    - enable: True
    - watch:
      - file: /etc/apache2/mods-enabled/dir.conf
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load
      - file: /etc/apache2/mods-available/php7.4.conf


