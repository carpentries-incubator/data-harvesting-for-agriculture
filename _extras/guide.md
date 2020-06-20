---
layout: page
title: "Instructor Notes"
---

## A Note on Our Philosophy

We are targeting working farmers and certified crop advisors (CCAs).  We do not and should not expect them to prepare complex analytical codes from scratch on the basis of a two-day workshop.  We have instead decided to package much of the analytical logic into a set of functions in `functions.R`, allowing us to focus on higher-level

We highly recommend finding helpers who can help participants import data from various sources in order to understand how to adapt these tools to their own farm's working procedures.  Augment, don't displace, their tools.

## Workshop Pages

There are some places where our pages still refer to the University of Illinois' particular setup.  These are marked with `XXX` in HTML comment tags.  You should modify these instructions for your own hosting.  (Ultimately, these should be replaced with inclusions for Jekyll.)

## Setup Instructions

We have found that student setup can take an inordinate amount of time, particularly on Windows machines which require a large download to install R and RStudio.  The setup instructions presume that the instructor or host will provide USB drives pre-loaded with the necessary materials for both Windows and Mac machines.  (We anticipate a vanishingly small segment of the farming community to be using Linux on their daily machines.)

These USB drives should contain the following, updated for current versions of the packages.

```
.
├── DataHarvestingMac
│   ├── PackageTarFiles
│   │   ├── broom_0.5.4.tgz
│   │   ├── data.table_1.12.8.tgz
│   │   ├── daymetr_1.4.tgz
│   │   ├── dplR_1.7.0.tgz
│   │   ├── FedData_2.5.7.tgz
│   │   ├── ggplot2_3.2.1.tgz
│   │   ├── gstat_2.0-4.tgz
│   │   ├── list_of_locations_for_packages.txt
│   │   ├── lubridate_1.7.4.tgz
│   │   ├── measurements_1.4.0.tgz
│   │   ├── raster_3.0-12.tgz
│   │   ├── rgdal_1.4-8.tgz
│   │   ├── sf_0.8-1.tgz
│   │   └── tmap_2.3-2.tgz
│   ├── qgis-macos-pr.dmg
│   ├── R-3.3.3.pkg
│   ├── R-3.6.2.pkg
│   ├── RStudio-1.2.5033.dmg
│   └── WorkingDir
│       └── data
├── DataHarvestingWin
│   ├── C-path Start links
│   │   ├── QGIS 3.10 Start Menu links
│   │   └── R and R Studio Start Menu links
│   ├── D-path Start links
│   │   ├── QGIS 3.10 Start Menu links
│   │   └── R and R Studio Start Menu links
│   ├── ProgramFiles
│   │   ├── QGIS 3.10
│   │   ├── R
│   │   └── RStudio
│   ├── StandaloneInstallers
│   │   ├── QGIS-OSGeo4W-3.10.2-2-Setup-x86_64.exe
│   │   ├── R-3.6.2-win.exe
│   │   └── RStudio-1.2.5033.exe
│   └── WorkingDir
│       └── data
├── README.txt
```

<!-- TODO make a script for this and a GitHub repo -->

## RStudio and Multiple R Installs

Some learners may have previous R installations. On Mac, if a new install is
performed, the learner's system will create a symbolic link, pointing to the new
install as 'Current.' Sometimes this process does not occur, and, even though a
new R is installed and can be accessed via the R console, RStudio does not find
it. The net result of this is that the learner's RStudio will be running an
older R install. This will cause package installations to fail. This can be
fixed at the terminal. First, check for the appropriate R installation in the
library;

```
ls -l /Library/Frameworks/R.framework/Versions/
```

We are currently using R 3.x.y If it isn't there, they will need to install it.
If it is present, you will need to set the symbolic link to Current to point to
the 3.x.y directory:

```
ln -s /Library/Frameworks/R.framework/Versions/3.x.y /Library/Frameworks/R.framework/Version/Current
```

Then restart RStudio.


## Technical Tips and Tricks

- Show students how to use the `Zoom` button to examine graphs without constantly resizing windows.

- Sometimes a package will not install.  In that case, you should try a different CRAN mirror:  `Tools > Global Options > Packages > CRAN Mirror`

    Alternatively you can go to CRAN and download the package and install from ZIP file: `Tools > Install Packages`, set to `'from Zip/TAR'`

    It is important that R and the R packages be installed locally, not on a network drive. If a learner is using a machine with multiple users where their account is not based locally this can create a variety of issues (This often happens on university computers). Hopefully the learner will realize these issues before hand, but depending on the machine and how the IT folks that service the computer have things set up, it may be very difficult to impossible to make R work without their help.

    If learners are having issues with one package, they may have issues with another. It's often easier to make sure they have all the needed packages installed at one time, rather then deal with these issues over and over. [Here is a list of all necessary packages for these lessons.](https://github.com/datacarpentry/R-ecology-lesson/blob/master/needed_packages.R)

- Many exercises produce data files that are necessary downstream.  Please complete all exercises or double-check carefully before skipping an exercise.  If you need to catch someone up to a particular point, you can use the `lesson-catchup-scripts` to do so.


## Other Resources

If you encounter a problem during a workshop, feel free to contact the
maintainers by email or [open an
issue](https://github.com/datacarpentry/r-socialsci/issues/new).

For a more in-depth coverage of topics of the workshops, you may want to read "[R for Data Science](http://r4ds.had.co.nz/)" by Hadley Wickham and Garrett Grolemund.
