#include "./headers/getDateRange.h"

/******************************************************************************************/
/*  Program:                                                                              */
/*    - 'getDateRange'                                                                    */
/* Main program to retrieve dates during which a star is observable in the STEREO-A HI-1  */
/* field of view for a specified STEREO-A orbit.                                          */
/*                                                                                        */
/*  Input arguments:                                                                      */
/*    - 1 (star.name):                   Name of Star                                     */
/*    - 2 (star.RAhms, star.DECdms):     Celestial coordinates of star                    */
/*    - 3 (dir.base):                    Base directory of Download Bash script           */
/*    - 4 (dir.HI1A_data):               Base directory of STEREO HI-1A image fits files  */
/*    - 5 (star.orbit):                  STEREO-A orbit number                            */
/*  Output:                                                                               */
/*    - dates:                           Orbit start_end dates: YYYMMDD_YYYMMDD           */
/******************************************************************************************/

int main(int argc, char *argv[])
{

/*
  TIME variable initialization */
  const int dt = 40;                 /* Time between images in minutes (image cadence) */
  const int ipd = 36;                /* Number of images per day */
  const int N_days = 40;             /* Total number of days to process */
  const int TL = N_days*ipd;         /* Limiting number of images to acquire (over-estimates number needed) */
  int it;                            /* Image timestamp index */
  int date_ymd[3], time_hms[3];      /* Date array: [y m d], UTC Time array: [h m s] */
  char datestring[9];
  char startdate[9];
  char dates[20];

  TARG star;                         /* Star characteristics structure */
  PTH dir;                           /* Directory paths structure */

/********************************************
  Distribute input arguments to variables   */
  distArgs(argc, argv, &star, &dir);

/**************************************************
  Convert Right Ascension to degrees   */

  star.RAdeg  = RAhms2deg(star.RAhms);

/***************************************
  Calculate analysis start date & time */

  getStartDate(star.orbit, star.RAdeg, date_ymd, dir.base);

  sprintf(startdate, "%04d%02d%02d",date_ymd[0],date_ymd[1],date_ymd[2]);

/******************************
  Loop over time increments   */

  for (it = 0; it < TL; it++)
  {

/******************************************
  Calculate current image date/time and place into respective arrays */
    if (image_date_time(date_ymd, time_hms, dt, it) < 0)
    {
      break;
    }

    // Create date string
    sprintf(datestring, "%04d%02d%02d",date_ymd[0],date_ymd[1],date_ymd[2]);

  } /* End of 'it' time itertation loop processing single images into pixel stamps */

  sprintf(dates,"%s_%s", startdate, datestring);
  printf("%s", dates);

  return 0;

} /* End of program */
