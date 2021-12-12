/etc/skel/public_html/testi.php:
  file.managed:
    - source: salt://phpfile/testi.php
    - makedirs: True

##/home/vagrant/public_html/testi.php:
##  file.managed:
 ##   - source: salt://phpfile/testi.php
 ##   - makedirs: True
