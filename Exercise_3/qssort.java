import java.util.*;
import java.io.*;

interface State {
    public boolean isFinal();
    public Collection<State> next();
    public String getMoves();
    public void print();
}

class QSstate implements State {
    private Queue<Integer> solved;
    private Queue<Integer> queue;
    private Stack<Integer> stack;
    private String moves;

    //constructor
    public QSstate(Queue<Integer> sol, Queue<Integer> q, Stack<Integer> s, String m){
        solved = sol;
        queue = q;
        stack = s;
        moves = m;
    }

    @Override 
    public boolean isFinal() {
        Queue<Integer> temp_solved = new ArrayDeque<Integer>(solved);
        Queue<Integer> current_queue = new ArrayDeque<Integer>(queue);
        boolean flag = true;
        if(temp_solved.size() != current_queue.size()){
            return false;
        }
        while(!current_queue.isEmpty()){
            Integer qval = current_queue.remove();
            Integer solVal = temp_solved.remove();
            if(qval != solVal){
                flag = false;
                break;
            } 
        }
        return flag;
    }

    @Override
    public Collection<State> next(){
        Collection<State> states = new ArrayList<>();
        if(!queue.isEmpty()){
            Queue<Integer> temp_q = new ArrayDeque<Integer>(queue);
            Stack<Integer> temp_s = (Stack<Integer>)stack.clone();
            Integer temp = temp_q.remove();
            temp_s.push(temp);
            State move = new QSstate(solved, temp_q, temp_s, moves+'Q');
            states.add(move);
        }
        if(!stack.isEmpty()){
            if(!queue.isEmpty() && stack.peek() != queue.peek()){
                Queue<Integer> temp_q = new ArrayDeque<Integer>(queue);
                Stack<Integer> temp_s = (Stack<Integer>)stack.clone();
                Integer temp = temp_s.pop();
                temp_q.add(temp);
                State move = new QSstate(solved, temp_q, temp_s, moves+'S');
                states.add(move);
            }
        }
        return states;
    }

    @Override
    public String getMoves(){
        return moves;
    }
    @Override
    public void print(){
        System.out.println(solved);
        System.out.println(queue);
        System.out.println(stack);
        System.out.println(moves);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        QSstate other = (QSstate) o;
        Queue<Integer> other_queue = new ArrayDeque<Integer>(other.queue);
        Queue<Integer> this_queue = new ArrayDeque<Integer>(queue);
        if(this_queue.size() != other_queue.size()) return false;
        boolean flag = true;
        while(!this_queue.isEmpty()){
            Integer qval = this_queue.remove();
            Integer solVal = other_queue.remove();
            if(qval != solVal){
                flag = false;
                break;
            } 
        }
        Stack<Integer> this_stack = (Stack<Integer>)stack.clone();
        Stack<Integer> other_stack = (Stack<Integer>)other.stack.clone();
        if(this_stack.size() != other_stack.size()) return false;
        while(!this_stack.isEmpty()){
            Integer qval = this_stack.pop();
            Integer solVal = other_stack.pop();
            if(qval != solVal){
                flag = false;
                break;
            } 
        }
        return flag;
    }

    @Override
    public int hashCode() {
        //hash function idea by https://www.baeldung.com/java-hashcode
        int ret=1, prime=43;
        for(int val : queue){
            ret = ret * prime + val;
        }
        for(int val : stack){
            ret = ret * prime + val;
        }
        return ret;
    }
}

interface Solver {
    public String solve(State initial);
}

class BFSolver implements Solver {
    @Override
    public String solve (State initial) {
        Set<State> seen = new HashSet<>();
        Queue<State> remaining = new ArrayDeque<>();
        remaining.add(initial);
        while(true){
            State s = remaining.remove();
            //s.print();
            if (s.isFinal()) return s.getMoves();
            for (State n : s.next())
                if(!seen.contains(n)){
                    remaining.add(n);
                    seen.add(n);
                }
        }
    }
}

public class QSsort {
    public static void main(String args[]){
        try{
            Solver solver = new BFSolver();
            Queue<Integer> q1 = new ArrayDeque<Integer>();
            Queue<Integer> q = new ArrayDeque<Integer>();
            Stack<Integer> s = new Stack<Integer>();
            //read
            BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            String line = reader.readLine();
            Integer N = Integer.parseInt(line);
            Integer array[] = new Integer[N];
            line = reader.readLine();
            String[] num = line.split(" ");
            for(int i=0; i<N; i++){
                Integer a = Integer.parseInt(num[i]);
                q.add(a);
                array[i]=a;
            }
            Arrays.sort(array);
            for(int i=0; i<N; i++){
                q1.add(array[i]);
            }
            State initial = new QSstate(q1,q,s,"");
            String result = solver.solve(initial);
            printSolution(result);
        }
        catch(IOException e) {
            e.printStackTrace();
        }
    }

    private static void printSolution(String s){
        if(s == ""){
            System.out.println("empty");
        }
        else{
            System.out.println(s);
        }
    }
}   
