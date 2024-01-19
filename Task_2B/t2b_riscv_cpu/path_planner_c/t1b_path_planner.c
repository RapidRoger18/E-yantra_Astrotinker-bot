
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
    // uint8_t *path_planned = (uint8_t*) 0x02000010;
    uint8_t path_planned[32];
    // index to keep track of the path_planned array
    uint8_t idx = 0;

    // ############# Add your code here #############
// uint16_t *map = (uint16_t*) 0x02000010;
uint16_t map[68];
map[ 0 ] = 11 ;                //1 = 0 + 1 
map[ 1 ] = 301 ;               //1 = 1 + 0
map[ 2 ] = 321 ;               //3 = 1 + 2
map[ 3 ] = 591 ;               //30 = 1 + 29
map[ 4 ] = 611 ;               //3=2+1
map[ 5 ] = 632 ;               //5=2+3
map[ 6 ] = 683 ;               //10 = 2+8
map[ 7 ] = 922 ;               //5 = 3+2
map[ 8 ] = 943 ;               //7 = 3+4
map[ 9 ] = 1186 ;              //31 = 3+28
map[ 10 ] = 1233 ;             //7 = 4+3
map[ 11 ] = 1251 ;             //9 = 4+5
map[ 12 ] = 1264 ;             //10 = 4+6
map[ 13 ] = 1541 ;             //9 = 5+4
map[ 14 ] = 1844 ;             //10 6+4
map[ 15 ] = 1874 ;             //13 6+7
map[ 16 ] = 2164 ;             //13 = 7+6
map[ 17 ] = 2181 ;             // 15 = 7+8
map[ 18 ] = 2423 ;             //10 = 8+2 
map[ 19 ] = 2471 ;             //15 = 8+7
map[ 20 ] = 2491 ;              //17 = 8+9
map[ 21 ] = 2523 ;              //20= 8+ 12
map[ 22 ] = 2781 ;              //17= 9+8
map[ 23 ] = 2801 ;              //19 = 9+10
map[ 24 ] = 2811 ;              //20 = 9+11
map[ 25 ] = 3091 ;              //19 = 10 + 9
map[ 26 ] = 3391 ;              //20 = 11 + 9
map[ 27 ] = 3683 ;              //20 = 12 + 8
map[ 28 ] = 3736 ;              // 25 = 12+13
map[ 29 ] = 3796 ;              //31 = 12+19
map[ 30 ] = 4026 ;              //25 = 13+12
map[ 31 ] = 4045 ;              //27 = 13 + 14
map[ 32 ] = 4335 ;              //27 = 14+ 13
map[ 33 ] = 4351 ;              //29 = 14+15
map[ 34 ] = 4364 ;              //30 = 14+16
map[ 35 ] = 4641 ;              //29 = 15+14
map[ 36 ] = 4944 ;              //30 = 16+14
map[ 37 ] = 4971 ;              //33 = 16+17
map[ 38 ] = 4985 ;              //34 = 16+18 
map[ 39 ] = 5261 ;              //33 = 17+16
map[ 40 ] = 5565 ;              //34 = 18+16
map[ 41 ] = 5596 ;              //37 = 18 +19
map[ 42 ] = 5826 ;              //37 = 19+12
map[ 43 ] = 5886 ;              //31 = 19+18
map[ 44 ] = 5903 ;              //19+20
map[ 45 ] = 6193 ;              //39 = 20+19
map[ 46 ] = 6211 ;              //39= 20+21
map[ 47 ] = 6241 ;              //41 = 20+24
map[ 48 ] = 6293 ;              //44 = 20+29
map[ 49 ] = 6501 ;              //49+ 21+20
map[ 50 ] = 6521 ;              //41 = 21+22
map[ 51 ] = 6531 ;              //43 = 21+23
map[ 52 ] = 6811 ;              //44 = 22+21
map[ 53 ] = 7111 ;              //41 = 23+21
map[ 54 ] = 7401 ;              //44 = 24+20
map[ 55 ] = 7454 ;              //44 = 24+25
map[ 56 ] = 7744 ;              //49 = 25+24
map[ 57 ] = 7764 ;              //49 = 25+26
map[ 58 ] = 8054 ;              //51= 26+25
map[ 59 ] = 8071 ;              //51 = 26+27
map[ 60 ] = 8083 ;              //53 = 26+28
map[ 61 ] = 8361 ;              //54 = 27+26
map[ 62 ] = 8436 ;              //53 = 28+3
map[ 63 ] = 8663 ;              //31 = 28+26
map[ 64 ] = 8692 ;              //54 = 28+29
map[ 65 ] = 8711 ;              //57 = 29+1
map[ 66 ] = 8903 ;              //57 = 29+20
map[ 67 ] = 8982 ;              //30 = 29+28

uint8_t parent[30];
bool checked[30];
uint8_t node_dist[30];
// uint8_t *parent =  (uint8_t*) 0x020000D4;                        // to check which node has been analysed
// bool *checked = (bool*) 0x020000B6;                      // bool array(true=node_checked false=node_unchecked)
// uint8_t *node_dist = ( uint8_t* ) 0x02000098;                     // to store distance between nodes while calculating path
uint8_t temp, tempo;
uint16_t value = 0, value1 = 0;
uint8_t mapped;
    for (int b = 0; b < 30; b++)        //initialize parent & checked array at infi. dist.(relatively large) for all nodes & no node checked
    {
        node_dist[b]= 255;            
        checked[b]=false;
    }
    node_dist[END_POINT]=0;            // set all indexes to start values in node_dist and parent arrays
    parent[END_POINT]=255;
    for (int j = 0; j < 29; j++)        //runs 29 times for 29 relations(30 nodes , 29 relations)
    {
        uint8_t min_val = 255, min_index;
        for (int k = 0; k < 30; k++)
        {
            if(checked[k]==false&&node_dist[k] < min_val){        // checking condition for shortest dist
                min_val=node_dist[k];
                min_index=k;
            }
        }
        checked[min_index]=true;
        for (int l = 0; l < 30; l++)
        {
            mapped = 0;
            for (int y = 0; y < 68; y++){
                if ( map[y] > ((min_index*30 + l) * 10) &&( map[y] - ((min_index*30 + l) * 10) ) > 0 && ( map[y] - ((min_index*30 + l) * 10) ) < 10 ){
                    mapped = map[y] - ((min_index*30 + l) * 10);
                }
            }
            if(!checked[l]&&mapped&&node_dist[min_index]+mapped<node_dist[l]){
                parent[l]=min_index;
                node_dist[l]=node_dist[min_index]+mapped;
            }
        }
    }
    temp=START_POINT;
   
    for(int z=0;z<30;z++){                        // loop to print planned path
        if(parent[temp]==255)
        { path_planned[z]=(temp);
        idx+=1;
            break;
        }    
        path_planned[z]=(temp);
        temp=parent[temp];
        idx+=1;
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
