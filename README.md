# Data Harvesting for Agriculture

Agriculture is an intensely data-driven field, but many farmers, agronomists, and CCAs don’t have computer science backgrounds. In this two-day workshop, researchers from the University of Illinois will teach you about free tools you can use with your own farm’s data to improve your fertilizer application rates, look at conditions across time, and more.

This workshop offers lessons on data management for agriculture, targeting farmers and certified crop advisors who wish to work directly with the data from their instruments and available from online resources.  We aim to offer this workshop annually during the "lull season" from after harvest until planting.

[Click here to watch our video overview.](https://cdnapisec.kaltura.com/p/1329972/sp/132997200/embedIframeJs/uiconf_id/26883701/partner_id/1329972?iframeembed=true&amp;playerId=kaltura_player&amp;entry_id=1_3b8cyu1k&amp;flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en&amp;flashvars[ks]=djJ8MTMyOTk3Mnx5ZOFalX4G6QrClcJam1l3_XzfNRaltJ5JfW1GUefJUbYTJx1p-vNxXGzCYPtJWKAUflEVIp2Rpq-fAipVe-BHQaGyJm4E_aOCfOQkbKqUY_E-kmSmzFyfV5PcxnDFgFVbEEEjuI8Q-M3pKqGqnXXn1gTblms82-XXKP2jcNJ7G0AK6WsBvQGVezqxqNfwuZfNhHuPia_BJeLXxq3lCHGzrrvCVLL1t2BxJC6ACYErFiCk4QeX1eNzMnn3OBKq9ofl1KNntKxNXPtKsfS2uGxv5-L-bA5iX0p6AhRPcVgmeFNqduDFQcJIK6ez8uRLfAQ9K4l09fYH2h5uxL6LshfRsEYCQ2ukR8PwqMdp4VOsr-kzGOxk4bnvEN1vxINCKbSOe62_L8Ot4pISosMW6bpd&amp;flashvars[leadWithHTML5]=true&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[hotspots.plugin]=1)


## Contributors:

- Lindsay Clark (PI)

- Carrie Butts-Wilmsmeyer
- [Neal Davis](https://www.github.com/davis68)
- Brittani Edge
- Aolin Gong
- Jill Naiman
- Dena Strong

Maintained by [Neal Davis](https://www.github.com/davis68).


## Contact & Involvement

Contact Lindsay Clark or Neal Davis, both at the University of Illinois, for more information, at [`data-harvesting@illinois.edu`](mailto:data-harvesting@illinois.edu).


## Support

These lessons are made possible by a grant from the [Center for Digital Agriculture](https://digitalag.illinois.edu/) at the University of Illinois.


## Building the Site

This site uses the Carpentries template with Jekyll.  In order to build the site, you will need to install R and Ruby, then use the following to get your machine up-to-date.

### macOS

### Windows

### Linux (Ubuntu)

```
# Install R and RStudio separately, then:
sudo apt install libudunits2-dev libgdal-dev libgmp3-dev jekyll
R -e "install.packages('sf', repos='http://cran.rstudio.com/')"
R -e "install.packages('FedData', repos='http://cran.rstudio.com/')"
R -e "library(devtools);install_github('igraph/rigraph')"
# if the above fails and you have Anaconda Python installed, you need to
# move `anaconda` to `anaconda.bak` temporarily to "break" the gfortran.so.4
# link it finds
# per https://github.com/igraph/rigraph/issues/275
make site
```
