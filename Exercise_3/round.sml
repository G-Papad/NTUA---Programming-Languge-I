local
(* finds the sum for each city *)
fun distancefromcity l city cnum = 
    let 
        fun findDif [] city sum cities = sum
          | findDif (h::t) city sum cities =  
          		if city >= h then findDif t city (sum+city-h) cities
          		else findDif t city (sum+cities - h + city) cities
    in
        findDif l city 0 cnum
    end

(* finds the max for each city *)
fun furthestfromcity l city cnum =
    let 
        fun help [] city num ans = ans
          | help (h::t) city num ans = 
          let
          	fun findDif cur_city city cities = if cur_city <= city then city - cur_city
          				  else cities - cur_city + city 
          	val dif = findDif h city num
          in
          	if dif > ans then help t city num dif
          	else help t city num ans 
          end 
    in 
        help l city cnum 0
    end 

fun solve carlist cnum = 
    let
        fun solve_help _ [] _ _ moves finalCity = (moves, finalCity)
            |solve_help l (h::t) cur_city cities moves finalCity =
                let
                    val sumDif = distancefromcity l cur_city cities
                    val maxDif = furthestfromcity l cur_city cities 
                in
                    if (sumDif - maxDif) >= (maxDif - 1) then
                        if moves > sumDif then solve_help l t (cur_city+1) cities sumDif cur_city
                        else solve_help l t (cur_city+1) cities moves finalCity
                    else (*check answer with circle*)
                        let
                            fun isAdjacent [] city cities answer = answer
                              | isAdjacent (h::t) city cities answer = 
                              	let 
                              		val check = (city+1) mod cities
                              	in
                                    if check = h then isAdjacent t city cities true
                                    else isAdjacent t city cities answer
                                end
                            fun circle [] i cities sum = sum
                              | circle (h::t) i cities sum =
                              	if(h <> i) then 
                              		if(h < i) then circle t i cities (sum+i-h)
                              		else circle t i cities (sum+cities-h+i)
                              	else
                              		circle t i cities sum
                             val adjacent = isAdjacent l cur_city cities false
                             val circle_sum = circle l cur_city cities 0
                        in
                            if adjacent then 
                                if (circle_sum+cities) < moves then solve_help l t (cur_city+1) cities (circle_sum+cities) cur_city
                                else solve_help l t (cur_city+1) cities moves finalCity
                            else
                                if (circle_sum+2*cities) < moves then solve_help l t (cur_city+1) cities (circle_sum+2*cities) cur_city
                                else solve_help l t (cur_city+1) cities moves finalCity								
                        end
                end
    in
        solve_help carlist carlist 0 cnum (valOf Int.maxInt) ~1
    end

fun parse file =
    let
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    	val inStream = TextIO.openIn file

		val n = readInt inStream
		val k = readInt inStream
		val _ = TextIO.inputLine inStream

		fun readInts 0 acc = rev acc
		  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   		(n, k, readInts k [])
    end
    
in

fun round infile = 
    let
        val input = parse infile
        val n = #1 input
        val k = #2 input
        val carPos = #3 input
        val solution = solve carPos n
    in
        print(Int.toString (#1 solution));
        print(" ");
        print(Int.toString(#2 solution))
    end
end
