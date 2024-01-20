
/*
* AstroTinker Bot (AB): Task 1B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
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


// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t CPU_DONE            = 0;

    #else

        #define START_POINT         (* (volatile uint8_t * ) 0x20000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x20000001)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x20000003)

    #endif

    // array to store the planned path
    uint8_t path_planned[32];

    // index to keep track of the path_planned array
    uint8_t idx = 0;

    // instead of using printf() function for debugging,
    // use the below function calls to print a number, string or a newline

    // for newline: _put_byte('\n');
    // for string:  _put_str("your string here");
    // for number:  _put_value(your_number_here);

    // Examples:
    // _put_value(START_POINT);
    // _put_value(END_POINT);
    // _put_str("Hello World!");
    // _put_byte('\n');

    // ############# Add your code here #############

int map[30][30] = { {0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},        //30 X 30 array that stores distance of each node from its nearest nodes(default dist.0)
                    {1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
                    {0,1,0,2,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,2,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0},
                    {0,0,0,3,0,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,4,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,3,0,0,0,0,1,0,1,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,3,0,0,0,0,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,6,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,1,5,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,6,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,1,0,0,1,0,0,0,0,3},
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,4,0,0,0,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,4,0,0,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,1,3,0},  
                    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},  
                    {0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,2},  
                    {0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,2,0}   
};

int parent[30];                        // to check which node has been analysed
bool checked[30];                      // bool array(true=node_checked false=node_unchecked)
int node_dist[30];                     // to store distance between nodes while calculating path
int temp;
    for (int b = 0; b < 30; b++)        //initialize parent & checked array at infi. dist.(relatively large) for all nodes & no node checked
    {
        node_dist[b]=10000;            
        checked[b]=false;
    }
    node_dist[END_POINT]=0;            // set all indexes to start values in node_dist and parent arrays
    parent[END_POINT]=-1;
    for (int j = 0; j < 29; j++)        //runs 29 times for 29 relations(30 nodes , 29 relations)
    {
        int min_val = 10000, min_index;
        for (int k = 0; k < 30; k++)
        {
            if(checked[k]==false&&node_dist[k]<=min_val){        // checking condition for shortest dist
                min_val=node_dist[k];
                min_index=k;
            }
        }
        checked[min_index]=true;
        for (int l = 0; l < 30; l++)
        {
            if(!checked[l]&&map[min_index][l]&&node_dist[min_index]+map[min_index][l]<node_dist[l]){
                parent[l]=min_index;
                node_dist[l]=node_dist[min_index]+map[min_index][l];
            }
        }
    }
    temp=START_POINT;
    
    for(int z=0;z<30;z++){                        // loop to print planned path
        if(parent[temp]==-1)
        { path_planned[z]=(temp);
        //_put_value(path_planned[idx]);
        idx+=1;
            break;
        }    
        path_planned[z]=(temp);
        temp=parent[temp];
        idx+=1;
    }

    // ##############################################

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}
