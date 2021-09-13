local
fun null [] = true
  | null _  = false;
  	
fun head [] 	= raise Empty
  | head (h::t) = h;
 
fun tail [] 	= raise Empty
  | tail (h::t) = t;	
        
fun removeHead [] = []
  | removeHead [h] = []
  | removeHead (h::t) = t;
 
fun triple f l = f(f (f l));
        

fun imout (a,b) n m =
    if(a<0 orelse b<0 orelse a = n orelse b = m)
    then true
    else false
    
fun move (a,b) #"U" = (a-1,b)
  | move (a,b) #"D" = (a+1,b)
  | move (a,b) #"L" = (a,b-1)
  | move (a,b) #"R" = (a,b+1)
  | move (a,b)  _   = (a,b)
  
fun mapped (a,b) m = a*m + b

fun makePath (a,b) n m maze visited path = 
    if imout (a,b) n m then (1,path) else
    if (Array.sub(visited, (mapped (a,b) m))) = 0 then (
        Array.update(visited, (mapped (a,b) m), 2);
        makePath (move (a,b) (Array.sub(maze, mapped (a,b) m))) n m maze visited ((mapped (a,b) m)::path)
    )
    else(
        if (Array.sub(visited, (mapped (a,b) m))) = ~1 orelse (Array.sub(visited, (mapped (a,b) m))) = 2 then (~1,path)
        else (1,path)
    )

fun changeVisited (_,[]) visited = ()
  | changeVisited (~1,(h::t)) visited  = (Array.update(visited, h, ~1); changeVisited(~1, t) visited)
  | changeVisited (1, (h::t)) visited  = (Array.update(visited, h, 1); changeVisited(1, t) visited)
  
fun myLoop i j n m maze visited = (
    changeVisited (makePath (i,j) n m maze visited []) visited;
    if(i<n) then myLoop (i+1) j n m maze visited else (
    if(j<m) then myLoop 0 (j+1) n m maze visited else ())
)

fun findAnswer i size answer visited =
    if i<size then (
    if((Array.sub(visited, i)) = ~1) then
    findAnswer (i+1) size (answer+1) visited else
    findAnswer (i+1) size answer visited
    )
    else answer
    
fun parse file =
    let
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        
        val inStream = TextIO.openIn file
        val (n,m) = (readInt inStream, readInt inStream)
    	fun next_String input = (TextIO.inputAll input) 
    	val stream = TextIO.openIn file
    	val a = next_String stream
    in
    	(n,m,explode(a))
    end  
    
fun makelist l acc =
    if null l then (rev acc) else
    (if Char.isSpace(head l) orelse Char.isDigit(head l) then makelist (tail l) acc else makelist (tail l) ((head l)::acc))

fun first (a,_,_) = a
fun second (_,b,_) = b
fun third (_,_,c) = c

in

fun loop_rooms infile = 
    let
        val a = parse infile
        val n = first a
        val m = second a
        val mazeTemp = makelist (third a) [] 
        val maze = Array.fromList mazeTemp
        val visited = Array.array ((n*m), 0)
        val temp = myLoop 0 0 n m maze visited
        val res = findAnswer 0 (n*m) 0 visited
     in
     	print (Int.toString res)
     end

end
