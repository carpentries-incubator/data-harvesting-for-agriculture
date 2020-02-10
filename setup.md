---
layout: page
title: Setup
---

## Setup instructions

Put together, there are about 4 to 5 Gb of software and data to install.
This takes some time over most home network connections, so if you don't have
the time or bandwidth to do this in advance, we are creating installed USB drives 
that you can copy from.

**If you want to take the software with you, we recommend that you copy it to your
computer's C drive. The Center for Digital Agriculture needs the USB drives back
at the end of the workshop.**

**R** and **RStudio** are separate programs. R is the
underlying statistical computing environment, but using R alone is no
fun. RStudio is a graphical integrated development environment (IDE) that makes
using R much easier and more interactive. You need to install R before you
install RStudio. Once installed, because RStudio is an IDE, RStudio will run R 
in the background.  You do not need to run it separately. 

## If you want to work from the USB drives

### Use the "start menu" folder for where you want to use it
When these USB drives were created, they were assigned the letter D on a Windows computer.
However, if you copy to your own computer's hard drive, that will probably be C.

On Windows, you can skip the 5 Gb download process by copying the DataHarvestingWin folder
to the root level of your C drive and running it from  there. (Your new path should be
C:\DataharvestingWin\ as opposed to the old path of D:\DataHarvestingWin\.) 

### Launching the programs (Windows)
Within DataHarvestingWin, the folders with Start Menu in their names contain shortcuts
to run the software.

Choose the version that corresponds to the drive you're planning to run it from --
C if you copy the folders to your own computer, and probably D if you run from the USB
drive. 

If you're running from USB but it wasn't assigned the letter D, find:

 **DataHarvestingWin/ProgramFiles/RStudio/bin/rstudio.exe**\
    (and)\
 **DataHarvestingWin/ProgramFiles/R/R-3.6.2/R.exe**

and double-click them to run.

The first time you run R Studio, you'll be prompted to select your installation of R. 

1. Choose the **"Choose a specific version of R"** item next to the large text box.
2. Use the **Browse** button to navigate to:

 **DataHarvestingWin/ProgramFiles/R/R-3.6.2/** 

and choose **Select Folder.**

3. You'll be given a choice between 32 bit and 64 bit; either should work, but 64 bit
is likely to be what your computer is capable of.

If the Start folder's shortcut doesn't work for you in QGIS, and you get an error message about a 
missing DLL, there's a location mismatch to resolve. Ask a class helper for assistance 
in switching the .env file that you're using.

### Launching the programs from the USB drive (Mac)

**NEED MAC INFO HERE**

<hr>

## If you choose to install before the workshop begins

### Windows
If you're installing R, R Studio, and QGIS before the workshop begins, you can follow these
instructions instead.

**R and R Studio:**

* Download R from
  the [CRAN website](http://cran.r-project.org/bin/windows/base/release.htm).
* Run the `.exe` file that was just downloaded
* Go to the [RStudio download page](https://www.rstudio.com/products/rstudio/download/#download)
* Under *Installers* select **RStudio x.yy.zzz - Windows
  Vista/7/8/10** (where x, y, and z represent version numbers)
* Double click the file to install it
* Once it's installed, open RStudio to make sure it works and you don't get any
  error messages.
* When RStudio is open and working, create a new R script file and copy in the 
contents of [this file](https://github.com/data-carpentry-for-agriculture/trial-lesson/blob/gh-pages/_episodes_rmd/package_install_script.R). Run each line in this script. (Note that this
process will likely take 3 - 4 hours on Windows 10 because of virus checking procedures
that were already taken care of on the USB keys. If you can wait for the USB keys, you'll have
a faster way to get up and running.)


### macOS

**UPDATE WITH JENNY'S INFO**

* Download R from
  the [CRAN website](http://cran.r-project.org/bin/macosx/).
* Select the `.pkg` file for the latest R version
* Double click on the downloaded file to install R
* It is also a good idea to install [XQuartz](https://www.xquartz.org/) (needed
  by some packages)
* Go to the [RStudio download page](https://www.rstudio.com/products/rstudio/download/#download)
* Under *Installers* select **RStudio x.yy.zzz - Mac OS X 10.6+ (64-bit)**
  (where x, y, and z represent version numbers)
* Double click the file to install RStudio
* Once it's installed, open RStudio to make sure it works and you don't get any
  error messages.


