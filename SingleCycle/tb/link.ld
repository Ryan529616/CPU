ENTRY(_start) /* 設定程式入口 */

SECTIONS
{
    /* 設定程式起始位址 */
    . = 0x0;

    /* 配置 .text 段：可讀、可執行，但不可寫 */
    .text : {
        *(.text)
    } >FLASH /* 假設 .text 放在執行空間 (如 FLASH) */

    /* 配置 .data 段：可讀、可寫，但不可執行 */
    .data : {
        *(.data)
    } >RAM AT >FLASH /* 假設 .data 從 FLASH 複製到 RAM */

    /* 配置 .bss 段：只用於未初始化的全域變數 */
    .bss : {
        *(.bss)
    } >RAM /* .bss 一般位於 RAM 中 */
}
