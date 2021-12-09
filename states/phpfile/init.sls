/etc/skel/public_html/testi.php:
  file.managed:
    - source: salt://phpfile/testi.php
    - makedirs: True

/var/www/html/testi.php:
  file.managed:
    - source: salt://phpfile/testi.php
