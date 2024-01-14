#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#if defined(__linux__) || defined(__APPLE__) // for the host pc

    #include <stdio.h>

    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }

        // print the characters in reverse order (from right to left)
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint8_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint8_t val) { }
    void _put_str(char *str) { }

#endif
struct Node {
  int row;
  int col;
  int dist;
};

int main(int argc, char const *argv[]){
     #if defined(__linux__) || defined(__APPLE__)

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;

    #else
        // Address value of variables are updated for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif

    // array to store the planned path
    uint8_t path_planned[32];
    // index to keep track of the path_planned array
    uint8_t idx = 0;
struct Node map[] = {
  {0, 1, 1},
  {1, 0, 1},
  {1, 29, 1},
  {2, 3, 2},
  {2, 8, 3},
  {3, 4, 3},
  {3, 9, 6},
  {3, 28, 6},
  {4, 5, 1},
  {4, 6, 4},
  {5, 8, 1},
  {6, 5, 4},
  {6, 7, 4},
  {8, 2, 3},
  {8, 4, 1},
  {8, 10, 1},
  {9, 8, 1},
  {9, 10, 1},
  {9, 11, 1},
  {11, 8, 3},
  {11, 13, 6},
  {11, 19, 6},
  {12, 13, 5},
  {12, 14, 1},
  {12, 16, 4},
  {13, 14, 1},
  {13, 15, 4},
  {14, 16, 1},
  {15, 17, 1},
  {15, 18, 5},
  {18, 20, 3},
  {18, 22, 1},
  {18, 29, 3},
  {19, 20, 1},
  {20, 21, 1},
  {21, 22, 1},
  {21, 28, 4},
  {22, 27, 4},
  {22, 29, 1},
  {23, 26, 4},
  {26, 28, 4},
  {26, 29, 1},
  {27, 29, 3},
  {28, 3, 6},
  {28, 18, 1},
  {28, 26, 3},
  {29, 1, 1},
  {29, 10, 2}
};
int size = sizeof(map) / sizeof(map[0]);
uint8_t parent[30];
bool checked[30];
uint8_t node_dist[30];
uint8_t temp;
uint8_t mapped;

    for (uint8_t b = 0; b < 30; b++) {
        node_dist[b] = 255;
        checked[b] = false;
    }
    node_dist[END_POINT] = 0;
    parent[END_POINT]=255;

    for (uint8_t j = 0; j < 29; j++) {
        uint8_t min_val = 255, min_index;
        for (uint8_t k = 0; k < 30; k++) {
            if (!checked[k] && node_dist[k] <= min_val) {
                min_val = node_dist[k];
                min_index = k;
            }
        }
        checked[min_index] = true;
        for (uint8_t l = 0; l < 30; l++) {
            for (int i = 0; i < size; i++) {
                if (map[i].row == min_index && map[i].col == l) {
                    mapped = map[i].dist;
                }
                else mapped = 0;
            }
            if (!checked[l] && mapped && node_dist[min_index] + mapped < node_dist[l]) {
                parent[l] = min_index;
                node_dist[l] = node_dist[min_index] + mapped;
            }
        }
    }
    temp = START_POINT;
    for (uint8_t z = 0; z < 30; z++) {
        path_planned[z] = temp;
        temp = parent[temp];
        idx += 1;
        if(temp == END_POINT) break;
        }


    // ##############################################	

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #if defined(__linux__) || defined(__APPLE__)    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}
