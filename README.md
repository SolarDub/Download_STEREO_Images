:construction_worker: WORK IN PROGRESS :construction_worker:

# Download_STEREO_Images
This routine will download STEREO-A Heliospheric Imager-1 20°×20° star-field images from NASA/GSFC database, based on a user-defined data range, or the appearance of a user-selected star during a user-selected STEREO orbit.

## Requirements

The routine will work with Python 3.7 or later. [Astroquery](https://github.com/astropy/astroquery/), an affiliated package of [astropy](http://www.astropy.org/), should be installed as the download routine uses one or more of its sub-packages. Go to the [astroquery](https://github.com/astropy/astroquery/) for installation instructions, but it may be most useful to use the [pip](https://pypi.python.org/pypi/pip) command:

    $ pip install --pre astroquery[all]


to ensure that all the mandatory dependencies are install prior to installing [astroquery](https://github.com/astropy/astroquery/).

## Help scripts

To access the help file, which lists the usable switches, at the terminal prompt, type

    $ ./Download_STEREO_Images.sh --help


## Initializing

Before running the download routine, the usable directory paths and remote URL paths need to be checked/updated.

#### Checking URL Path

To check the URL path, at the prompt, type:

    $ ./Download_STEREO_Images.sh -u


A prompt will pop up requesting the base URL from where the FITS images files will be downloaded. This should be automatically filled with:

`https://stereo-ssc.nascom.nasa.gov/pub/ins_data/secchi_hi/L2/a/img/hi_1`

If not, this URL should be copied and pasted into the prompt field.

#### Updating Directory Paths

To update the directory paths, at the prompt, type:

    $ ./Download_STEREO_Images.sh -d


On execution of the routine, it should read in the directory path to the location of the routine script. This should automatically fill the field of the first prompt. If not, press OK twice to exit the program. At the prompt type:

    $ pwd


and copy the printed directory path. Run the program again with the ``-d`` switch and paste in the copied directory path. For example:

`/Users/jdoe/Documents/Research/stereo/Download_STEREO_Images/`

and press OK. The next prompt asks where the FITS images directories and files should exist. This will have to be updated. For example enter:

`/Users/jdoe/Documents/Research/stereo/h1A/`

and press OK.

Using the program to download the FITS images will then place them in their repective directories. For example, the file named:

`20160310_000901_24h1A_br01.fits`

will be placed into

`/Users/jdoe/Documents/Research/stereo/h1A/2016/03/10/`


## Downloading Over a Range of Dates

Downloading FITS image files over a range of dates can be performed by entering at the terminal prompt:

    $ ./Download_STEREO_Images.sh -r


Two pop up prompts will follow requesting the start and end dates to be entered. Both should be in YYYYMMDD format:
- YYYY = four-digit year
- MM   = two-digit month
- DD   = two-digit day

The program will proceed to download the images files between the two dates and place them into their respective directories.



## Downloading Files Containing a Selected Star Observed During a Selected STEREO Orbit

This program can localize the download date range to acquire files that will contain a selected star across the dates during which it appears within a selected STEREO orbit. Typing at the prompt:

    $ ./Download_STEREO_Images.sh --ohelp


will list a table of orbit numbers and their respective start and end dates and times. For example, Orbit 10 starts at 10 2015/09/27, 21:47:25 and ends at 2016/09/06, 09:43:58. Selecting the observation of a star during Orbit 10 will download FITS image files at and around the dates during which the star appears in the field of view of the telescope.

To select a star and orbit, type at the prompt:

    $ ./Download_STEREO_Images.sh -s


A pop up prompt will appear requesting the name of the star of interest. This is followed by a second prompt requesting the Orbit number during which the observation of the star took place. The start and end dates of the FITS image files to be downloaded will be displayed and the download will commence.

Note that after entering the star name, the star's coordinates will be retrieved from SIMBAD using an [astroquery](https://github.com/astropy/astroquery/) sub-package. Incidentally, if only the coordinates of the star are required without running the download procedure, this can be performed by typing at the prompt:

    $ ./Download_STEREO_Images.sh -c


Again, the pop-up prompt requesting the name of the star of interest will appear. On entering the star name, the coordinates will appear and the program will terminate.
