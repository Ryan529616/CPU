module quicksort_dpi;

    // 宣告動態未打包陣列
    int array[];  

    // 使用 Open Array 的 DPI-C 聲明
    import "DPI-C" function void dpi_quicksort(inout int array[], input int size);

    initial begin
        // 初始化動態陣列
        array = new[10];
        array = '{10, 5, 7, 2, 8, 3, 9, 1, 6, 4};

        $display("Before sorting:");
        foreach (array[i]) $write("%0d ", array[i]);
        $display("");

        // 呼叫 C 函數
        dpi_quicksort(array, array.size());

        // 顯示排序後的結果
        $display("After sorting:");
        foreach (array[i]) $write("%0d ", array[i]);
        $display("");
    end

endmodule
