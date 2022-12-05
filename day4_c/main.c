#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_LINES 1000
#define MAX_CHARS_PER_LINE 15

int main(int argc, char* argv[]) {
    clock_t start = clock();

    if (argc != 2) {
        printf("Error: expected one argument\n");
        return 1;
    }

    FILE* fp = fopen(argv[1], "r");

    if (fp == NULL) {
        printf("Error: could not open file %s\n", argv[1]);
        return 1;
    }

    char* lines[MAX_LINES];
    int numLines = 0;
    char line[MAX_CHARS_PER_LINE + 1];

    while (fgets(line, sizeof(line), fp) != NULL) {
        size_t len = strlen(line);
        if (line[len - 1] == '\n') {
            line[len - 1] = '\0';
        }

        if (len > MAX_CHARS_PER_LINE) {
            printf("Error: line %d is too long\n", numLines + 1);
            return 1;
        }

        lines[numLines] = malloc(len);
        if (lines[numLines] == NULL) {
            printf("Error: could not allocate memory for line\n");
            return 1;
        }

        strcpy(lines[numLines], line);
        numLines++;
        if (numLines >= MAX_LINES) {
            break;
        }
    }

    fclose(fp);

    int subsetRangeCount = 0;
    int overlappingRangeCount = 0;
    for (int i = 0; i < numLines; i++) {
        char* elf1 = strtok(lines[i], ",");
        char* elf2 = strtok(NULL, ",");

        int elf1StartJob = atoi(strtok(elf1, "-"));
        int elf1EndJob = atoi(strtok(NULL, "-"));

        int elf2StartJob = atoi(strtok(elf2, "-"));
        int elf2EndJob = atoi(strtok(NULL, "-"));

        if (elf1StartJob <= elf2StartJob && elf1EndJob >= elf2EndJob)
            subsetRangeCount++;
        else if (elf2StartJob <= elf1StartJob && elf2EndJob >= elf1EndJob)
            subsetRangeCount++;

        if (elf1StartJob <= elf2StartJob && elf1EndJob >= elf2StartJob)
            overlappingRangeCount++;
        else if (elf2StartJob <= elf1StartJob && elf2EndJob >= elf1StartJob)
            overlappingRangeCount++;
    }
    printf("# of ranges where one fully contains the other: %d\n# of ranges that overlap at all : % d\n",
           subsetRangeCount, overlappingRangeCount);

    for (int i = 0; i < numLines; i++) {
        free(lines[i]);
    }

    clock_t end = clock();
    double elapsed = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Elapsed time: %f seconds\n", elapsed);

    return 0;
}
