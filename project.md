# LAMP & Muita ohjelmia

Miniprojekti luotu osana Tero Karvisen pitämää Palvelinten Hallinta kurssia.

Aloitin miniprojektin luomalla kaksi virtuaalikonetta vagrantilla, joista toinen tulee master-koneeksi, ja toinen slave-koneeksi. Molemmat koneet käyttivät Debian 11 Bullseye käyttöjärjestelmää.

Loin master-koneella ensimmäisen tilatiedoston, johon asetin vaadittavia, sekä muita hyödyllisiä ohjelmia minionille asennettavaksi.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/programs1.PNG)

Ajoin tilan minionille komennolla `sudo salt 'orja' state.apply programs`

Ohjelmat asentuivat odotetusti.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/asennusprograms.PNG)

Tämän jälkeen kokeilin aluksi masterilla käsin tehtynä, että asettamani tilat tulevat toimimaan.Siirryin muokkaamaan dir.conf tiedostoa apache2 hakemistossa, joka asettaa .php muotoiset tiedostot prioriteetiksi .html muodon sijaan.

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

## Lopputulos

Sain tavoitteeni onnistumaan, vaikka ne eivät suuria olleetkaan. Käynnissä oli samanaikaisesti useamman eri kurssin projekteja, joten minun piti kaventaa projektieni sisältöjä.

Luotu ympäristö ei ole kovin tietoturvallinen, mutta ne asetukset on helppo lisätä jälkeenpäinkin. 



## Lähteet

https://terokarvinen.com

https://digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-debian9

https://upcloud.com/community/tutorials/installing-lamp-stack-ubuntu/


