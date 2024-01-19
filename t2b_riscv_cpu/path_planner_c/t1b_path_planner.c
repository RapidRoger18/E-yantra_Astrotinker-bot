
/*
* AstroTinker Bot (AB): Task 1B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
* Updated memory addresses for Task 2B
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef __linux__ // for host pc

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

/*
Functions Usage

instead of using printf() function for debugging,
use the below function calls to print a number, string or a newline

for newline: _put_byte('\n');
for string:  _put_str("your string here");
for number:  _put_value(your_number_here);

Examples:
        _put_value(START_POINT);
        _put_value(END_POINT);
        _put_str("Hello World!");
        _put_byte('\n');

*/

// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

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

    // ############# Add your code here #############
    
    // uint16_t map[30][30] = { {0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},        //30 X 30 array that stores distance of each node from its nearest nodes(default dist.0)
    //                 {1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    //                 {0,1,0,2,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,2,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0},
    //                 {0,0,0,3,0,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,4,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,3,0,0,0,0,1,0,1,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,3,0,0,0,0,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,6,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,1,5,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,6,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,1,0,0,1,0,0,0,0,3},
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,4,0,0,0,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,0,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,1,3,0},  
    //                 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},  
    //                 {0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,2},  
    //                 {0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0}   
// };
uint16_t *map = (uint16_t*) 0x02000010;
map[ 0 ] = 11 ;
map[ 1 ] = 301 ;
map[ 2 ] = 321 ;
map[ 3 ] = 591 ;
map[ 4 ] = 611 ;
map[ 5 ] = 632 ;
map[ 6 ] = 683 ;
map[ 7 ] = 922 ;
map[ 8 ] = 943 ;
map[ 9 ] = 1186 ;
map[ 10 ] = 1233 ;
map[ 11 ] = 1251 ;
map[ 12 ] = 1264 ;
map[ 13 ] = 1541 ;
map[ 14 ] = 1844 ;
map[ 15 ] = 1874 ;
map[ 16 ] = 2164 ;
map[ 17 ] = 2423 ;
map[ 18 ] = 2471 ;
map[ 19 ] = 2491 ;
map[ 20 ] = 2523 ;
map[ 21 ] = 2781 ;
map[ 22 ] = 2801 ;
map[ 23 ] = 2811 ;
map[ 24 ] = 3091 ;
map[ 25 ] = 3391 ;
map[ 26 ] = 3983 ;
map[ 27 ] = 3736 ;
map[ 28 ] = 3796 ;
map[ 29 ] = 4026 ;
map[ 30 ] = 4045 ;
map[ 31 ] = 4335 ;
map[ 32 ] = 4351 ;
map[ 33 ] = 4364 ;
map[ 34 ] = 4641 ;
map[ 35 ] = 4944 ;
map[ 36 ] = 4971 ;
map[ 37 ] = 4985 ;
map[ 38 ] = 5261 ;
map[ 39 ] = 5565 ;
map[ 40 ] = 5596 ;
map[ 41 ] = 5826 ;
map[ 42 ] = 5886 ;
map[ 43 ] = 6193 ;
map[ 44 ] = 6211 ;
map[ 45 ] = 6241 ;
map[ 46 ] = 6293 ;
map[ 47 ] = 6501 ;
map[ 48 ] = 6521 ;
map[ 49 ] = 6531 ;
map[ 50 ] = 6811 ;
map[ 51 ] = 7111 ;
map[ 52 ] = 7401 ;
map[ 53 ] = 7454 ;
map[ 54 ] = 7744 ;
map[ 55 ] = 7764 ;
map[ 56 ] = 8054 ;
map[ 57 ] = 8071 ;
map[ 58 ] = 8083 ;
map[ 59 ] = 8361 ;
map[ 60 ] = 8436 ;
map[ 61 ] = 8663 ;
map[ 62 ] = 8692 ;
map[ 63 ] = 8711 ;
map[ 64 ] = 8903 ;
map[ 65 ] = 8982 ;

uint8_t *parent =  (uint8_t*) 0x020000D0;                        // to check which node has been analysed
bool *checked = (bool*) 0x020000B2;                      // bool array(true=node_checked false=node_unchecked)
uint8_t *node_dist = ( uint8_t* ) 0x02000094;                     // to store distance between nodes while calculating path
uint8_t temp;
uint8_t mapped;
    for (uint8_t b = 0; b < 30; b++)        //initialize parent & checked array at infi. dist.(relatively large) for all nodes & no node checked
    {
        node_dist[b]= 255;            
        checked[b]=false;
    }
    node_dist[END_POINT]=0;            // set all indexes to start values in node_dist and parent arrays
    parent[END_POINT]=255;
    for (uint8_t j = 0; j < 29; j++){        //runs 29 times for 29 relations(30 nodes , 29 relations)
        uint8_t min_val = 255, min_index;
        for (int k = 0; k < 30; k++)
        {
            if(checked[k]==false&&node_dist[k]<=min_val){        // checking condition for shortest dist
                min_val=node_dist[k];
                min_index=k;
            }
        }
        checked[min_index]=true;
        for (uint8_t l = 0; l < 30; l++){
            for (uint8_t y = 0; y < 65; y++) {
                uint8_t tempo = map[y] - (min_index * 30 + l) * 10;
                if (tempo >= 0 && tempo < 10) {
                mapped = tempo;
                break;
                } else mapped = 0;
            } 
            if(!checked[l]&&mapped && node_dist[min_index]+mapped < node_dist[l]){
                parent[l]=min_index;
                node_dist[l]=node_dist[min_index]+mapped;
            }
        }
    }
    temp=START_POINT;
   
    for(uint8_t z=0;z<30;z++){                        // loop to print planned path
        path_planned[z]=(temp);
        temp=parent[temp];
        idx+=1;
        if(temp==END_POINT){ 
            break;
        }    
    }


    // ##############################################

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}
