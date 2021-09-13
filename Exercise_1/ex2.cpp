#include <cstdio>
#include <vector>

bool imout (int *pos, int N, int M)	{
    if(pos[0] < 0 || pos[0] == N || pos[1] < 0 || pos[1] == M)
        return true;
    else
        return false;
}

int *move (int *pos, char dest)	{
    int *new_pos = new int[2];
    switch(dest)	{
        case 'U':
            new_pos[0] = pos[0]-1;
            new_pos[1] = pos[1];
            return new_pos;
            break;
        case 'D':
            new_pos[0] = pos[0]+1;
            new_pos[1] = pos[1];
            return new_pos;
            break;
        case 'L':
            new_pos[0] = pos[0];
            new_pos[1] = pos[1]-1;
            return new_pos;
            break;
        case 'R':
            new_pos[0] = pos[0];
            new_pos[1] = pos[1]+1;
            return new_pos;
            break;
        
        default:
            return new_pos;
            break;
            
    }
}

int map (int x, int y, int M)	{
    return x*M + y;
}

int *demap (int mapped, int M) {
    int *ret = new int[2];
    ret[0] = mapped/M;
    ret[1] = mapped%M;
    return ret;
}
    

int loop_rooms (int N, int M, char *maze)	{
    int size = N*M;
    int *path = new int[size];
    int *visited = new int[size];
    int res=0,count;
    int pos[2];
    
    for (int i=0; i<size; ++i)
        *(visited + i) = 0;
    
    for (int i=0; i<N; ++i){
        for(int j=0; j<M; ++j){
            pos[0] = i;
            pos[1] = j;
            count=0;
            while(!imout(pos,N,M))	{
                if(visited[map(pos[0],pos[1],M)] == 0)	{
                    path[count] = map(pos[0],pos[1],M);
                    count++;
                    visited[map(pos[0],pos[1],M)] = 2; //visited but not specified
                    pos[0] = *(move(pos, maze[map(pos[0],pos[1],M)]));	
                    pos[1] = *(move(pos, maze[map(pos[0],pos[1],M)])+1); 
                }
                else if(visited[map(pos[0],pos[1],M)] == -1){ //loop already discovered
                    for(int z=0; z<count; ++z){
                        visited[path[z]] = -1;
                    }
                    break;
                }
                else if(visited[map(pos[0],pos[1],M)] == 2){//current path is loop
                    for(int z=0; z<count; ++z){
                        visited[path[z]] = -1;
                    }
                    break;
                }
                else{//way out already discovered
                    for(int z=0; z<count; ++z){
                        visited[path[z]] = 1;
                    }
                    break;
                }
            }
            //code when current path goes out
            if(imout(pos,N,M)){
                for(int z=0; z<count; ++z){
                    visited[path[z]] = 1;
                }
            }
        }
    }
    for(int i=0; i<size; ++i){
        if(visited[i] == -1)
            res++;
    }
    
    return res;
}

int main(int argc, char **argv){
    FILE *fp;
    fp = fopen(argv[1], "r");
    int N,M,res;
    char c;
    fscanf(fp, "%d", &N);
    fscanf(fp, "%d", &M);
    fscanf(fp, "%c", &c);
    char *maze = new char[N*M]; 
    for(int i=0; i<N; ++i){
        for(int j=0; j<M; ++j){
            fscanf(fp, "%c", &c);
            maze[map(i,j,M)] = c;	
        }
        fscanf(fp, "%c", &c);
    }
    
    res = loop_rooms(N,M,maze);
    printf("%d", res);
    
    return 0;
}
