int x = 5;
int y = 3;

int add(int a, int b) {
    return a + b;
}

int main() {
    int z = add(x, y);
    int i = 0;
    while (i < 3) {
        if (i == 1) {
            z = z + 10;
        } else {
            z = z + 1;
        }
        i = i + 1;
    }
}
