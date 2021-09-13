import java.util.*;
import java.io.*;

class Solver {
    private List<Integer> initialState;
    private int cities;
    private int cars;

    public Solver(List<Integer> init, int numCities, int numCars){
        initialState = init;
        cities = numCities;
        cars = numCars;
    }
    
    public int[] solve(){
        int moves = Integer.MAX_VALUE;
        int finalCity=-1;
        int[] answer = new int[2];
        for(int i=0; i<cities; i++){
            int[] difandmax = findDif(i);
            int sumDif = difandmax[0];
            int maxDif = difandmax[1];
            // System.out.print(sumDif);
            // System.out.print(" ");
            // System.out.println(maxDif);
            if(sumDif - maxDif >= maxDif - 1){ //check answer without circle 
            //    System.out.println(i);
                if(moves > sumDif){
                    moves = sumDif;
                    finalCity = i;
                }
            }
            else{ //check answer with circle
                // System.out.println("else");
                // System.out.println(i);
                boolean adjacent = false;
                int sum = 0;
                int temp=0;
                for(int j=0; j<cars; j++){
                    temp=0;
                    int city = initialState.get(j);
                    if(city < i){
                        temp += i - city;
                    } 
                    else{
                        temp += cities - city + i; 
                    }
                    if(city != i){
                        if((i+1) % cities == city){
                            adjacent = true;
                        }
                        sum+=temp;
                    }
                }
                // System.out.print("sum: ");
                // System.out.println(sum);
                // System.out.print(adjacent);
                if(adjacent){
                    sum += cities;
                }
                else{
                    sum += 2*cities;
                }
                // System.out.println(sum);
                // System.out.println("end_else");
                if(sum < moves){
                    moves = sum;
                    finalCity = i;
                }
            }
            answer[0] = moves;
            answer[1] = finalCity;
        }
        return answer;
    }

    private int[] findDif(int city){
        int sumDif=0;
        int maxDif=0;
        int dif;
        for(int i=0; i < cars; i++){
            if(city >= initialState.get(i)){
                dif = city - initialState.get(i);
            }
            else{
                dif = cities - initialState.get(i)+city;
            }
            sumDif+=dif;
            if(dif> maxDif) maxDif = dif;
        }
        int[] ret = new int[2];
        ret[0] = sumDif;
        ret[1] = maxDif;
        return ret;
    }

}

public class Round {
    public static void main(String args[]){
        try{
            //read
            BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            String line = reader.readLine();
            String[] num = line.split(" ");
            Integer N = Integer.parseInt(num[0]);
            Integer K = Integer.parseInt(num[1]);
            List<Integer> carsPos = new ArrayList<Integer>();
            line = reader.readLine();
            num = line.split(" ");
            for(int i=0; i<K; i++){
                Integer a = Integer.parseInt(num[i]);
                carsPos.add(a);
            }
            Solver solver = new Solver(carsPos, N, K);
            int[] solution = solver.solve();
            printSolution(solution[0],solution[1]);
        }
        catch(IOException e) {
            e.printStackTrace();
        }       
    }

    private static void printSolution(int m, int c){
        System.out.print(m);
        System.out.print(" ");
        System.out.println(c);
    }
}   
