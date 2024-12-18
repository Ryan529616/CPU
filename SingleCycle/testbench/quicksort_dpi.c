#include "svdpi.h"
#include <stdio.h>

void dpi_quicksort(const svOpenArrayHandle h) {
    int size = svSize(h, 1); // 獲取陣列大小
    int *array = (int *)svGetArrElemPtr1(h, 0); // 獲取指標

    if (!array || size <= 0) {
        printf("Error: Invalid array or size\n");
        return;
    }

    // 快速排序邏輯
    void quicksort(int *arr, int low, int high);
    quicksort(array, 0, size - 1);

}

// 快速排序輔助函數
void quicksort(int *arr, int low, int high) {
    if (low < high) {
        int pivot = arr[high];
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }

        int temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;

        quicksort(arr, low, i);
        quicksort(arr, i + 2, high);
    }
}
