#LAMP & Muita ohjelmia

Aloitin miniprojektin luomalla kaksi virtuaalikonetta vagrantilla, joista toinen tulee master-koneeksi, ja toinen slave-koneeksi.

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

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/testiphp.PNG)


