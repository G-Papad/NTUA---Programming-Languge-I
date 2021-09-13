#include <cstdio>
#include <iostream>
#include <vector>

using namespace std;

int min(int a, int b)	{
    if(a <= b)
        return a;
    else
        return b;
}

int max(int a, int b)	{
    if(a >= b)
        return a;
    else 
        return b;
}

void prefix_Array(int arr[], int size)	{
    for(int i=1; i<size; ++i)	
        arr[i] += arr[i-1];
}

void addto_Array(int arr[], int size, int num)	{
    for(int i=0; i<size; ++i)
        arr[i] += num;
}

int longest_span(int arr[], int size, bool flag)	{
    int Right_min[size], Left_max[size];
    int res = -1;
    
    Left_max[0] = arr[0];
    for(int i=1; i<size; ++i)	
        Left_max[i] = max(arr[i], Left_max[i-1]);

    Right_min[size-1] = arr[size-1];
    for(int i=size-2; i > -1; --i)
        Right_min[i] = min(arr[i], Right_min[i+1]);

    int i=0;
    int j=0;

    while(i<size && j<size)	{
        if(Right_min[j] <= Left_max[i])	{
            res = max(res, j-i);
            if(i==0 && flag)
                res++;
            ++j;
        }	
        else{
            ++i;
        }
    }
    return res;
            
}

int ex1 (int arr[], int M, int N, bool flag)	{

    addto_Array(arr, M, N);
    prefix_Array(arr, M);
    return longest_span(arr, M, flag);
}


int main(int argc, char **argv)	{
    
    FILE *fp;
    fp = fopen(argv[1], "r");
    
    int buff;
    vector<int> temp;
    
    while(fscanf(fp, "%d", &buff)!=EOF)	{
        temp.push_back(buff);	
    }
    
    int M = temp[0];
    int N = temp[1];
    int array[M];
    int res;
    bool flag;
        
    for(int i=0; i<M; ++i)	{
        array[i] = temp[i+2];
    }
            
    flag = array[0] <= -N;
    res = ex1(array, M, N, flag);
    printf("%d", res);
    
}
