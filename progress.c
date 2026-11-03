#include "progress.h"

Progress create_progress(int whatineedtodo)
{
    Progress progress = {
        .whatineedtodo = whatineedtodo,
        .whatihavedone = 0,
        .lastprogresspersantage = -1,
        .big_bang = z_time(),
    };

    return progress;
}

void set_progress(Progress *progress, int whatihavedone)
{
    progress->whatihavedone = whatihavedone;
}

void showoff_progress(Progress *progress)
{
    printf("\033[K");
    int perentage = progress->whatihavedone * 100 / progress->whatineedtodo;

    if (perentage == 100) {
        printf("\rDone. took ");
        z_time_print_elapsed_seconds(progress->big_bang);
        return;
    }

    // avoid printing when progress hasn't improved
    if (progress->lastprogresspersantage == perentage) {
        return;
    }

    printf("\r%d%%", perentage);
    fflush(stdout);
    progress->lastprogresspersantage = perentage;
}
