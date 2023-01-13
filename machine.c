#include <stdio.h>
#include <stdlib.h>
#include "VSM.h"

#define TraceSW 0

int main(int argc, char* argv[])
{
    FILE *fp;
    int a1, a2;
    double a3;
    fp = fopen(argv[1], "r");
    if (fp == NULL){
        printf("objectfile not open\n");
        exit(-1);
    }

    while(fscanf(fp, "%d,%d,%lf", &a1, &a2, &a3) != EOF){
        SetI(a1, a2, a3);
        
    }
    fclose(fp);
    printf("Enter execution phase\n");            /* あった ? */
      if (StartVSM(0, TraceSW) != 0)           /* プログラム実行 */
        printf("Execution aborted\n");
}
