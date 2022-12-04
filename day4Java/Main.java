import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {

    static class Range {
        private int start;
        private int end;

        public Range(String[] values) {
            this.start = Integer.parseInt(values[0]);
            this.end = Integer.parseInt(values[1]);
        }

        public boolean isOverLapping(Range range) {

            if(this.end < range.start || this.start > range.end){
                return false;
            }else if(range.end < this.start || range.start > this.end){
                return false;
            }

            return true;
        }

        public boolean isFullOverLap(Range range) {

            if(this.start >= range.start && this.end <= range.end ){
                return true;
            }else if(range.start >= this.start && range.end <= this.end ){
                return true;
            }

            return false;
        }
    }

    public static void main(String[] args) {
        try {
            File myObj = new File("real.txt");
            Scanner myReader = new Scanner(myObj);
            int fullOcc = 0;
            int occ = 0;
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                boolean fullOverlap = isFullOverLap(data);
                if (fullOverlap){
                    fullOcc++;
                }
                boolean overlap = isOverLap(data);
                if (overlap){
                    occ++;
                }
            }
            System.out.println(fullOcc);
            System.out.println(occ);
            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An errorFile occurred.");
            e.printStackTrace();
        }
    }

    private static boolean isFullOverLap(String data) {
        String[] sections = data.split(",");
        Range first = new Range(sections[0].split("-"));
        Range second = new Range(sections[1].split("-"));

    
        return first.isFullOverLap(second);
    }


    private static boolean isOverLap(String data) {
        String[] sections = data.split(",");
        Range first = new Range(sections[0].split("-"));
        Range second = new Range(sections[1].split("-"));

    
        return first.isOverLapping(second);
    }
}