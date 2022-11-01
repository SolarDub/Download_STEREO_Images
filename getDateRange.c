#include "./headers/getDateRange.h"

int main(int argc, char *argv[])
{

/****************************************************************************************/
/* Main program to read HI-1A images from a series of .fits files during a given orbit  */
/* for a selected star. Flux values for a pixel can be found.                           */
/****************************************************************************************/

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

/*
  INPUT FILE arrays initialization */
  char file_name[120];               /* Filename of current HI-1A fits image */

/*
  STAMP array initialization */
  float stamp[N_STAMP][N_STAMP];     /* Star single image stamp array */

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
