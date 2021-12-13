# LAMP 

Miniprojekti luotu osana Tero Karvisen pitämää Palvelinten Hallinta kurssia.

Aloitin miniprojektin luomalla kaksi virtuaalikonetta vagrantilla, joista toinen tulee master-koneeksi, ja toinen slave-koneeksi. Molemmat koneet käyttivät Debian 11 Bullseye käyttöjärjestelmää.

Loin master-koneella ensimmäisen tilatiedoston, johon asetin vaadittavia, sekä muita hyödyllisiä ohjelmia minionille asennettavaksi.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/programs1.PNG)

Ajoin tilan minionille komennolla `sudo salt 'orja' state.apply programs`

Ohjelmat asentuivat odotetusti.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/asennusprograms.PNG)

Tämän jälkeen kokeilin aluksi masterilla käsin tehtynä, että asettamani tilat tulevat toimimaan.Siirryin muokkaamaan dir.conf tiedostoa apache2 hakemistossa `/etc/apache2/mods-enabled`, joka asettaa .php muotoiset tiedostot prioriteetiksi .html muodon sijaan.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/apachepref.PNG)

Vaihdoin siis index.php ensimmäiseksi heti DirectoryIndex:n jälkeen. 

Käynnistin tämän jälkeen apache2:n uudestaan, jotta asetukset tulevat varmasti voimaan. 

Siirryin `/var/www/html` hakemistoon, johon loin testi.php nimisen tiedoston kokeillakseni, että php toimii apache2:n avulla.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/testiphpfile.PNG)

Kokeilin curlia käyttäen, että sivu toimii varmasti, sillä koska kyseessä on vagrant kone, en pystynyt kokeilemaan graafisella käyttöliittymällä selainta käyttäen.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/curltesti.PNG)

Asettamani sisältö siis toimi. 

Otin vielä käyttöön apache2:lla käyttäjien omat kotihakemistot, jotta uudetkin käyttäjät orja-koneella voivat käyttää omia kotisivujaan. 

Tämä tapahtui komennolla `a2enmod userdir`.

Nyt kun olin kokeillut kaiken tavoitteistani toimivan, siirryin editoimaan init.sls tiedostoja, jotta saan asetukset myös orjalla käyttöön.

Ensiksi kuitenkin kopioin editoimani apache2:n `dir.conf` tiedoston, sekä `testi.php` tiedoston samaan hakemistoon.

Asetin tilan, joka luo tiedoston käyttäen masteri-koneella olevaa valmista tiedostoa.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/initslsdirconf.PNG)

Sitten loin symboliset linkit userdir.conf ja userdir.load tiedostojen välille. 

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/symlinkit.PNG)
 
Asetin myös apache2:n käynnistymään uudelleen, jos tiedostoihin jotka asetin `watch` komennon alapuolelle tulee muutoksia.

Viimeiseksi lisäsin myös rivit, jotka kopioi luomani testi.php tiedoston orjakoneelle, sekä `/etc/skel` alapuolelle, jotta uudet käyttäjät saavat sen käyttöönsä, sekä myös `var/www/html` alapuolelle, jotta se löytyy myös koneen omasta hakemistosta, ja on myös root käyttäjän käytettävissä.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/testiphp1.PNG)

Ajoin tilat orjalle komennolla `sudo salt 'orja' state.apply programs`, ja sain vastaukseksi kaikkien tilojen onnistuneen.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/orjaonnistui.PNG)

Varmuuden vuoksi siirryin vielä orja-koneelle johon loin uuden käyttäjän `tatutesti1`, jotta näen myös käsin muutosten tulleen voimaan. 

Siirryin luodun käyttäjän kotihakemistoon josta edelleen `public_html` hakemistoon, jossa sijaitsi aiemmin luomani testi.php.

Kokeilin vielä curlin avulla komennolla `http://localhost/testi.php`, ja huomasin tilan toimineen.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/orjauusikayttis.PNG)

Nyt kun olin saanut kaikki muut toiminnallisuudet luotua, piti vielä luoda tietokanta, joka yhdistyisi myös apacheen. Tässä kohtaa tuli kuitenkin ongelmia.

## Käsin tehtynä

Yritin tehdä käsin ensiksi host-koneella, mutta en saanut php sivuja toimimaan. Löysin [Stackoverflowsta](https://stackoverflow.com/questions/51420077/apache2-not-executing-php-scripts-on-debian-stretch) apua, että piti editoida `/etc/apache2/mods-available/php7.4.conf` tiedostoa seuraavanlaisesti.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/editoituphpconf.PNG)

Kommentoitiin siis ympyröidyt asetukset pois päältä. Tämän jälkeen piti käynnistää apache uudelleen, `sudo systemctl restart apache2.service`.

Sivut eivät selaimen kautta toimineet, vieläkään joten ongelmanratkaisu jatkui. Tällä kertaa kun kokeilin laittaa php7.4 moduulia päälle komennolla `sudo a2enmod php7.4`, sain virheilmoituksen. 

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/phpherja.PNG)

Löysin lisää apua, taas [Stackoverflowsta](https://stackoverflow.com/questions/47024111/apache-installing-and-running-php-files), jossa kerrottiin että ottamalla mpm_eventin pois käytöstä, ja laittamaan mpm_preforkin päälle, tämä toimisi. Kokeilin tätä komennoilla `sudo a2dismod mpm_event`, `sudo a2enmod mpm_prefork` ja nyt uudelleen `sudo a2enmod php7.4`, jonka jälkeen käynnistin uudelleen apache2:n `sudo systemctl restart apache2.service`. 

Nyt sain toimimaan host koneella selaimen kautta php sivun. Seuraavana vuorossa oli siis tietokannan luonti. Käytin kurssin opettajan Tero Karvisen luomaa [ohjetta mariadb:n](https://terokarvinen.com/2018/install-mariadb-on-ubuntu-18-04-database-management-system-the-new-mysql/) käytöstä. 

Loin ensimmäiseksi uuden tietokannan nimellä ukko, komennolla `create database ukko;`, jonka jälkeen annoin sille kaikki oikeudet komennolla `GRANT ALL ON ukko.* TO ukko@localhost IDENTIFIED BY '234234eioleoikeasalasana324';`. Kirjoitin `use ukko`, joka käyttää luomaani tietokantaa. Lisäsin yhden taulun komennolla `create table ukko(nimi CHAR(25))`. Tauluun lisäsin yhden rivin, Keijo. `insert into ukko(nimi) values ("Keijo");`.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mariadbukko.PNG)

Kokeilin vielä lisätä sen sivulleni, jotta se toimisi myös selaimessa. [Tero Karvisen](https://terokarvinen.com/2016/read-mysql-database-with-php-php-pdo/) sivuilla on tähänkin hyvä ohje. Kokeilin omaa versiotani siihen. 

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/phpdbtesti.PNG)

Tämän jälkeen kokeilin selaimella avata, ja kyllä siellä näkyi lisäämäni tietokannan rivi.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/localhostdbtesti.PNG)

Nyt kun kaikki toimi host koneella oikein käsin tehtynä, oli aika automatisoida tätä orjalle. 

## Automatisointi

Siirryin takaisin vagrant master koneelleni. Menin `/srv/salt/apache` hakemistooni, jonne kopioin `php7.4.conf` tiedoston, joka sijaitsi `/etc/apache2/mods-available` hakemistossa. Kommentoin ylempänä olevat kohdat taas pois. 

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/apacheconfphp.PNG)

Tämän jälkeen siirryin muokkaamaan testi.php tiedostoani samanlaiseksi kuin yllä käsin kokeilemani tiedosto. Salasana kannattaa olla vahva, jos aikoo tuotantoon laittaa kyseisen projektin.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/koiraphp.PNG)

Seuraavana oli vuorossa käyttäjän, sekä databasen luominen saltilla. Löysin [mariadb:n](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/) kotisivuilta paljon hyviä ohjeita tähän. Ensiksi pitää konfiguroida mariadb:n config tiedostoa, eli `my.cnf` tiedostoa. Tämä tiedosto sijaitsee `/etc/mysql` hakemistossa. Avasin tiedoston, ja huomasin kommenttirivin `"~/.my.cnf" to set user-specific options.`. 

Loin siis uuden .my.cnf tiedoston `/srv/salt/mariadb` hakemistoon. Ylläolevasta ohjeesta loin seuraavanlaisen tiedoston.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mycnf.PNG)

Väritin pois salasanan, mutta se tulisi myös `" "` merkkien väliin. Nyt kun käyttäjätiedot oli luotu, piti vielä luoda itse tietokanta. 

Löysin apua [Linuxhotsupportin](https://linuxhostsupport.com/blog/how-to-import-an-sql-file-into-mysql-database/) artikkelista. Päätin kokeilla tätä, ja loin backupdatabasen masterilla luomani databasen pohjalta komennolla `mysqldump -u koira -p salasana(tämäeioleoikeasalasana) > BackupDatabase.sql`. 

Kopioin BackupDatebase.sql:n `/srv/salt/mariadb` hakemistoon. Sitten piti vielä luoda salt-tilat.

Loin seuraavanlaisen init.sls tiedoston.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mariadbinit.PNG)

Kokeilin ajaa tiloja orjalle, mutta yksi niistä ei onnistunut, eli viimeisin rivi, jossa yritin importata tietokannan mariadbhen.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mariadbinitajo.PNG)

Löysin apua [Otso Raudan](https://otsorauta.wordpress.com/2018/12/03/h6-lamp-asennus-saltilla/) harjoituksesta samasta aiheesta. Hän loi harjoituksessaan kokonaan alusta .sql tiedoston, johon asetti tietokannan luomiskomennot.

Kokeilin samaa. Loin `createcommands.sql` tiedoston, johon syötin seuraavat tiedot.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/createcommands.PNG)

Peitin taas salasanan, mutta se tulisi `IDENTIFIED BY 'TÄHÄN'`. Hän oli myös laittanut tiedoston eri paikkaan orja-koneelle, joten muutin senkin rivin.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/uusmariadbinit.PNG)

Nämäkään tilat eivät toimineet minulla, vaan sain virheilmoituksen.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/virhe1.PNG)

Virheilmoitus sanoo, että tietokanta olisi jo olemassa. Kokeilin muuttaa kaikki `koira` kohdat sekä `.my.cnf`:stä sekä `createcommands.sql`:stä `koirat`:ksi.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/onnistuijes.PNG)

Tietokannan luonti onnistui. Muutokset kissa -> koirat johtuu siitä, että kokeilin ensin muuttaa koira:t kissa:ksi, jolloin huomasin muutoksen toimivan. Tarkistin vielä orja-koneella mariadb:stä, toimiko tämä.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mariadbonnistui.PNG)

Kyllä toimi. Katsoin vielä curlia käyttäen orjalla testi.php sivun sisältöä. Näytti oikealta. Selainta en pystynyt käyttämään, sillä kyseessä on vagrantkone.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/curlorjajee.PNG)

Mietin pitkään, miksi userdirit eivät menneet Saltin kautta päälle, ja huomasin virheen tilassani. Olin vahingossa kirjoittanut symlinkit samojen tiedostojen välille, joten korjasin tilan.

Nyt kaikki tilat toimivat idempotentteina.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/apacheidem.PNG)

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/phpidem.PNG)

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/programsidem.PNG)

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/mariadbidemp.PNG)

Muokkasin init.sls tiedostoja hieman erilaiseksi, uudemmat versiot päivitetty githubiin. Tärkeimmät muutokset, poistin mariadb -> init.sls tiedostosta `.my.cnf` tiedoston luomisen käyttäjälle vagrant, ja siirsin sen programs -> init.sls tiedostoon, joka luo sen uudelle käyttäjälle aina, kun uusi käyttäjä luodaan. Poistin myös phpfilen kokonaan, ja siirsin sen toiminnallisuudet programs-tilatiedostoon yksinkertaistaakseni toimintoja. 















## Lopputulos

Sain tavoitteeni onnistumaan. LAMP-stack asentui, sekä sain uploadattua luomani tietokannan .PHP sivulle. Tulos ei ole tietoturvallinen, mutta se ei ollutkaan tämän projektin tarkoitus.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/lopputulos.PNG)



## Lähteet

https://terokarvinen.com/2018/install-mariadb-on-ubuntu-18-04-database-management-system-the-new-mysql/

https://terokarvinen.com/2016/read-mysql-database-with-php-php-pdo/

https://digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-debian9

https://upcloud.com/community/tutorials/installing-lamp-stack-ubuntu/

https://stackoverflow.com/questions/51420077/apache2-not-executing-php-scripts-on-debian-stretch

https://stackoverflow.com/questions/47024111/apache-installing-and-running-php-files

https://mariadb.com/kb/en/configuring-mariadb-with-option-files/

https://otsorauta.wordpress.com/2018/12/03/h6-lamp-asennus-saltilla/

https://stackoverflow.com/questions/49373422/error-1007-hy000-at-line-1-cant-create-database-mgsv-database-exists/49373900
