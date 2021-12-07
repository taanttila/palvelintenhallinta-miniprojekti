#LAMP & Muita ohjelmia

Aloitin miniprojektin luomalla kaksi virtuaalikonetta vagrantilla, joista toinen tulee master-koneeksi, ja toinen slave-koneeksi.

Loin master-koneella ensimmäisen tilatiedoston, johon asetin vaadittavia, sekä muita hyödyllisiä ohjelmia minionille asennettavaksi.

[IMG](https://github.com/taanttila/palvelintenhallinta-miniprojekti/blob/main/screenshots/programs.png)

Ajoin tilan minionille komennolla `sudo salt 'orja' state.apply programs`

Ohjelmat asentuivat odotetusti.

[IMG](https://github.com/taanttila/palvelintenhallinta-miniprojekti/blob/main/screenshots/asennusprograms.PNG)

