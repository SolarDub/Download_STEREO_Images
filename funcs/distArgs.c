#include "./headers/distArgs.h"

/***********************************************************************************************/
/*  Function:                                                                                  */
/*    - 'distArgs'                                                                             */
/*  Inputs:                                                                                    */
/*    - argc:            Number of arguments passed to main executable                         */
/*    - argv:            Array of string arguments passed to main executable                   */
/*  Output:                                                                                    */
/*    - ptr_star:        Pointer to star properties structure                                  */
/*      - star:            Star name                                                           */
/*      - RAhms:           Right Ascension in hours, minutes, seconds                          */
/*      - DECdms:          Declination in degrees, minutes, seconds                            */
/*    - ptr_dir:         Pointer to directory paths structure                                  */
/*      - base:            Directory of executable, used for creating filepath to              */
/*                         orbit start/end time lookup table                                   */
/*      - HI1A_data:       Pointer to string filepath to base STEREO HI-1A data directory      */
/*      - stereo_star:     Pointer to string filepath to base stellar data directory           */
/*    - orbits:          Array of orbit numbers to be analysed                                 */
/***********************************************************************************************/

void distArgs(int argc, char *argv[], TARG *ptr_star, PTH *ptr_dir)
{


  /* Load star name from input arguments into variable */
  ptr_star->name = argv[1];

  /* Load star celestial (RA, Dec) coordinates from input arguments into respective arrays */
  for (int ic = 0; ic < 3; ic++){
    ptr_star->RAhms[ic]  = strtod(argv[ic+2],NULL);  /* h m s */
    ptr_star->DECdms[ic] = strtod(argv[ic+5],NULL);  /* d m s */
  }

  /* Load directory paths from input arguments into variables */
  ptr_dir->base        = argv[8];    /* Base directory (includes this program, etc) */
  ptr_dir->HI1A_data   = argv[9];    /* STEREO HI-1A base image fits file directory */

  /* Place orbit number from arguments into orbit member of star structure */
  ptr_star->orbit = strtod(argv[argc - 1],NULL); /* first_orbit_arg = argc - 1 (see main listing) */

}
