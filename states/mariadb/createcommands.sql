CREATE DATABASE koirat CHARACTER SET utf8;
GRANT ALL ON koirat.* TO koirat@localhost IDENTIFIED BY 'koirat';

USE koirat;
CREATE TABLE model(id INT AUTO_INCREMENT PRIMARY KEY, rotu VARCHAR(1024));
INSERT INTO model(rotu) VALUES ('saksanpaimenkoira');
INSERT INTO model(rotu) VALUES ('villakoira');
