local
    fun min (a,b) = if a<b then a else b;

    fun max (a,b) = if a<b then b else a;

    fun null [] = true
      | null _  = false;
      
    fun head [] 	= raise Empty
      | head (h::t) = h;
     
    fun tail [] 	= raise Empty
      | tail (h::t) = t;
     
    fun prefixArray l =
        let
            fun help(l,sum) = 
                if null l then [] else head l + sum :: help(tail l, sum + head l)
        in
            help(l,0)
        end;
        
    fun addToArray [] num = []
      | addToArray (h::t) num = h+num :: addToArray t num
     
    fun leftMax l =
        let 
            fun help (l, prevHead) = 
                if null l then [] else 
                    let 
                        val x = max(head l, prevHead) 
                    in
                        x :: help(tail l, x)
                    end 
        in 
            help (l, valOf(Int.minInt))
        end

    fun reverse l =
        let
            fun help (nil, a) = a
              | help (h::t, a) = help(t, h::a)
        in
            help(l, nil)
        end 

    fun rightMin l =
        let 
            fun help (l, prevHead) = 
                if null l then [] else 
                    let 
                        val x = min(head l, prevHead) 
                    in
                        x :: help(tail l, x)
                    end 
        in 
            reverse (help (reverse l, valOf(Int.maxInt)))
        end

    fun longestSpan l1 l2 exp =
        let 
            fun help (l1,l2,res,i,j,flag) = 
                let 		
                    val r = max (res,j-i)
                in
                    if null l2 then res else 
                    if null l1 then res else
                        if head l1 <= head l2 then 
                            (if (i=0 andalso flag) then help (tail l1, l2, r+1, i, j+1, flag)
                            else help (tail l1, l2, r, i, j+1, flag))
                        else help  (l1, tail l2, res, i+1, j,flag)
                end
        in
            help (l1, l2, ~1, 0, 0, exp)
        end
            
    fun chooseFromTuppleList (_,_,a) = a
    fun chooseFromTuppleNum (_,a,_) = a

    fun parse file =
        let
            fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
            val inStream = TextIO.openIn file
        	val m = readInt inStream
        	val n = readInt inStream

        	fun readInts 0 acc = rev acc 
        	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
        in
       		(m,n, readInts m [])
        end
in
    fun longest infile = 
        let
            val input = parse infile
            val buff = chooseFromTuppleList input
            val n = chooseFromTuppleNum input
            val a = addToArray buff n
            val prefix = prefixArray a
            val rMin = rightMin prefix
            val lMax = leftMax prefix
            val flag = (head buff) <= ~n
            val result = longestSpan rMin lMax flag
        in
            print (Int.toString result)
        end

end
