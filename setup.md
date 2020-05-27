---
layout: page
title: Setup
---

## Setup Instructions

Put together, there are about 4 to 5 Gb of software and data to install.  This takes some time over most home network connections, so we also provide USB drives with pre-installed data that you can copy the necessary files from.

**We have scheduled some time to complete the basic installation process together at the start of the workshop (about 30 minutes total)**, but if you want to try on your own before, please see the "Manual Installation in advance" section at the bottom of this page.

**R** and **RStudio** are separate programs. R is the underlying statistical computing software, but using R alone is more difficult and obscure. RStudio is a graphical integrated development environment (IDE) that makes using R much easier and more interactive. You need to install R before you install RStudio. Once installed, because RStudio is an IDE, RStudio will run R in the background.  You do not need to run it separately.

If you want to install on your own, Mac installation time should be much faster than what we've experienced on the Windows side:

- Macs tend to install the software quickly, in about 20 minutes
- Windows machines install the software from scratch in 3–4 hours.  You can instead copy the programs from one of our USB disks in 10–20 minutes.  **If you want to take the software with you, you will need to copy it to your computer. The Center for Digital Agriculture needs the USB drives back at the end of the workshop.**


## Mac: Installation Instructions

### Manual Installation (Preferred))

For Macs, you can follow the instructions at ["Installing R and RStudio on a Mac"](extra-Installing-R-on-Mac/index.html).

### USB-Based Installation

You can install from the USB drives at the workshop to save download time.
Macs won't allow you to run software from a USB drive the way Windows will, but we've copied the installation files here to save you the downloading time.


## Windows: Installation instructions

### USB-Based Installation (Preferred)

**Note: If you want to take the software with you, we recommend that you copy it to your computer's `C:` drive. The Center for Digital Agriculture needs the USB drives back at the end of the workshop.**

The Windows manual installation process has taken 3-4 hours to complete in our test runs, so we have two much-faster options available for you based on our USB drives which should only take about 10-20 minutes.

* If you want to keep the software and have about 5 Gb space free, at the workshop you can copy it from the USB stick to your computer's C drive.
* If you don't have about 5 Gb of space free, you can run the software directly on the USB drive. (However, we'll need the USB sticks back at the end of the workshop.)
* If you don't want to wait for the workshop and want to download and install before you arrive, see "Alternate: Manual installation in advance" below.

#### Steps to install using a USB drive:

1.  Copy the USB folder data to the correct hard drive.

    When these USB drives were created, they were assigned the letter `D:` on a Windows computer.  However, if you copy to your own computer's hard drive, that will probably be `C:`.

    On Windows, you can skip the 5 Gb download process by copying the `DataHarvestingWin` folder to the root level of your `C:` drive and running it from  there. (Your new path should be `C:\DataHarvestingWin` as opposed to the old path of `D:\DataHarvestingWin`.)

2.  Launch the programs

    Within DataHarvestingWin, the **folders with Start Menu in their names** contain shortcuts to run the software.

    Choose the version that corresponds to the drive you're planning to run it on:  `C:` if you copy the folders to your own computer, and `D:` (most likely) if you run from the USB drive.

    If you're running from USB but it wasn't assigned the letter D, find:

        DataHarvestingWin/ProgramFiles/RStudio/bin/rstudio.exe

    and double-click it to run.

    The first time you run RStudio, you'll be prompted to select your installation of R.

    1. Choose the **"Choose a specific version of R"** item next to the large text box.
    2. Use the **Browse** button to navigate to:

            DataHarvestingWin/ProgramFiles/R/R-3.6.2/

        and choose **Select Folder.**

    3. You have a choice between 32-bit and 64-bit; either should work, but 64-bit is more likely to fit a computer manufactured in the past decade.

    If the Start folder's shortcut doesn't work for you in QGIS, and you get an error message about a missing DLL, there's a location mismatch to resolve. Ask a class helper for assistance in switching the `.env` file that you're using.

### Manual Installation

You can follow the installation instructions at ["Installing R and RStudio on a Windows"](extra-Installing-R-on-Windows/index.html) page.  This may take several hours to complete on a Windows machine, and you shouldn't plan on having time to complete this during the workshop itself.
