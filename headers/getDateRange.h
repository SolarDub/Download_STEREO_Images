#ifndef createTPFs_H
#define createTPFs_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include "./headers/constants.h"
#include "./headers/struct_target.h"
#include "./headers/struct_path.h"

void distArgs(int argc, char *argv[], TARG *ptr_star, PTH *ptr_dir);
double RAhms2deg(double *RAhms);
int getStartDate(int orbit, double RAdeg, int *date_ymd, char *base_dir);
int image_date_time(int *date_ymd, int *time_hms, int dt, int it);

#endif // createTPFs_H
