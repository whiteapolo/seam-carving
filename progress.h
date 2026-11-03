#ifndef PROGRESS_H
#define PROGRESS_H

#include "libzatar/include/time.h"

typedef struct {
    int whatineedtodo;
    int whatihavedone;
    int lastprogresspersantage;
    Z_Time big_bang;
} Progress;

Progress create_progress(int whatineedtodo);
void set_progress(Progress *progress, int whatihavedone);
void showoff_progress(Progress *progress);

#endif
