#include <stdio.h>
#include <time.h>

#define SIZE 1000
int array[SIZE][SIZE];

int sum_row_major() {
    int sum = 0;
//add your code here work on the data raw major to shows the impact of using sequential memory
    for (int j = 0; j < SIZE; j++)
        for (int i = 0; i < SIZE; i++)
            sum += array[j][i];

    return sum;
}

int sum_column_major() {
    int sum = 0;
    for (int j = 0; j < SIZE; j++)
        for (int i = 0; i < SIZE; i++)
            sum += array[i][j];
    return sum;
}

int main() {
    clock_t start, end;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            array[i][j] = 1;

    start = clock();
    sum_row_major();
    free();
    end = clock();
    printf("Row-major time: %f sec\n", (double)(end - start) / CLOCKS_PER_SEC);

    start = clock();
    sum_column_major();
    free();
    end = clock();
    printf("Column    time: %f sec\n", (double)(end - start) / CLOCKS_PER_SEC);

    return 0;
}

