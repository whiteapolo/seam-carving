#include "flint.h"

void main(void)
{
	Cmd *cmd = cmd_new();
	cmd_append(cmd, "cc", "main.c", "-o", "exe");
	cmd_append(cmd, "-O3");
	cmd_append(cmd, "-lm", "-lSDL2", "-lSDL2_image");
	cmd_run(cmd);
}
