from collections import deque
from sys import argv

def QSgeneratorC(List, Stack, moves, Qcount):
    #check if already seen
    if (tuple(List), tuple(Stack)) not in visited:
        #Qmove
        if(List): #and (Qcount <= len(moves)//2)):
            QList = List.copy()
            QStack = Stack.copy()
            temp = QList.popleft()
            QStack.appendleft(temp)
            yield ((QList, QStack, moves+'Q', Qcount+1))
        #Smove
        if(Stack):# and (List[0] != Stack[0])):
            try:
                flag = (List[0] != Stack[0])
            except:
                flag = True
            if(flag):
                SList = List.copy()
                SStack = Stack.copy()
                temp = SStack.popleft()
                SList.append(temp)
                yield((SList,SStack,moves+'S', Qcount))

def pressC():
    a = input()
    while(a != 'c'): a = input()
    return
       
#function qssort 
def qssort_iterative(List,Stack):
    answer = "empty"
    moveList = deque([])
    Moves = ""
    Qcount = 0
    while (List != solved):
        next_moves = QSgeneratorC(List,Stack,Moves, Qcount)
        for nex in next_moves:
            moveList.append(nex)
        visited.add((tuple(List), tuple(Stack)))
        move = moveList.popleft()
        #print("Before List:", List)
        #print("Before Stack:", Stack)
        #print("move: ", move)
        List = move[0]
        #print("List: ", List)
        Stack = move[1]
        #print("Stack: ", Stack)
        Moves = move[2]
        Qcount = move[3]
        answer = Moves
        #pressC()
    return answer

Answer = -1
f = open(argv[1])
N = int(f.readline())
temp = f.read().split()
initQ = deque([])
for x in temp:
    initQ.append(int(x))
moveList = deque([])
initS = deque([])
solved = deque(sorted(initQ))
visited = set()
Answer = qssort_iterative(initQ,initS)
print(Answer)
