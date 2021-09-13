import sys

def imout(pos, N, M):
    return (pos[0] < 0 or pos[0] == N or pos[1] < 0 or pos[1] == M)
    
def move(pos, dest):
    if dest == "U":
        return (pos[0]-1,pos[1])
    elif dest == "D":
        return (pos[0]+1,pos[1])
    elif dest == "L":
        return (pos[0], pos[1]-1)
    else:
        return (pos[0], pos[1]+1)

def myMap(pos,M):
    return (pos[0]*M+pos[1])

def myDemap(mapped, M):
    return (mapped//M, mapped%M)
    
def loopRooms(N, M, maze):
    size = N*M
    res=0
    visited = [0] * size
    for i in range(N):
        for j in range(M):
            pos = (i,j)
            path = []
            while(not imout(pos, N, M)):
                mappedPos = myMap(pos,M)
                if(visited[mappedPos] == 0):
                    path.append(mappedPos)
                    visited[mappedPos] = 2
                    pos = move(pos,maze[mappedPos])
                    
                elif(visited[mappedPos] == -1):
                    for p in path:
                        visited[p] = -1
                    break
                elif(visited[mappedPos] == 2):
                    for p in path:
                        visited[p] = -1
                    break
                else:
                    for p in path:
                        visited[p] = 1
                    break
            
            if(imout(pos,N,M)):
                for p in path:
                    visited[p] = 1
    
    for i in range(size):
        if(visited[i] == -1):
            res = res + 1
    return res
    
f = open(sys.argv[1])
N, M = f.readline().split()
maze1 = f.read().split()
maze = []
for i in maze1:
    for a in i:
        maze.append(a)

print(loopRooms(int(N),int(M),maze))
