#LAMP & Muita ohjelmia

Aloitin miniprojektin luomalla kaksi virtuaalikonetta vagrantilla, joista toinen tulee master-koneeksi, ja toinen slave-koneeksi.

Loin master-koneella ensimmäisen tilatiedoston, johon asetin vaadittavia, sekä muita hyödyllisiä ohjelmia minionille asennettavaksi.

[Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/programs.PNG)

Ajoin tilan minionille komennolla `sudo salt 'orja' state.apply programs`

Ohjelmat asentuivat odotetusti.

![Image](https://raw.githubusercontent.com/taanttila/palvelintenhallinta-miniprojekti/main/screenshots/asennusprograms.PNG)

