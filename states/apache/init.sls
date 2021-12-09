/etc/apache2/mods-enabled/dir.conf:
  file.managed:
    - source: salt://apache/dir.conf

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: /etc/apache2/mods-enabled/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: /etc/apache2/mods-enabled/userdir.load

apache2:
  service.running:
    - enable: True
    - watch:
      - file: /etc/apache2/mods-enabled/dir.conf
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load
