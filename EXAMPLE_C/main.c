int main() {
    vga_clear();
    vga_putpixel(10, 10, 0xF800);  // bright red in RGB565
    puts("VGA Test");
    int c = getchar();
    return 0;
}
