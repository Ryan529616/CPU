#include <stdint.h>
int32_t data[] = {10, 5, 7, 2, 8, 3, 9, 1, 6, 4};
void quicksort(int32_t *array, int left, int right) {
    if (left >= right) return;

    int i = left, j = right;
    int32_t pivot = array[left + ((right - left) >> 1)];

    while (i <= j) {
        while (array[i] < pivot) i++;
        while (array[j] > pivot) j--;

        if (i <= j) {
            int32_t temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            i++;
            j--;
        }
    }

    quicksort(array, left, j);
    quicksort(array, i, right);
}

int main() {

    int size = sizeof(data) / sizeof(data[0]);

    quicksort(data, 0, size - 1);

    return 0;
}
