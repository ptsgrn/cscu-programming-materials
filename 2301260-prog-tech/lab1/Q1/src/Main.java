import java.util.Scanner;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.Duration;
import java.time.ZoneId;

public class Main {
    public static void main(String[] args) {
        ZoneId z = ZoneId.of( "Asia/Bangkok" );
        ZonedDateTime date = ZonedDateTime.now(z); // Create a date object
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        System.out.println("Current date: " + date.format(formatter));
        Scanner input = new Scanner(System.in);  // Create a Scanner object
        System.out.print("Enter day: ");
        int day = input.nextInt();
        System.out.print("Enter month: ");
        int month = input.nextInt();
        System.out.print("Enter year: ");
        int year = input.nextInt();
        ZonedDateTime newDate = ZonedDateTime.of(year, month, day, 0, 0, 0, 0, z);
        long dayDiff = Duration.between(date.toInstant(), newDate).toDays();
        System.out.println("Number of days: " + (dayDiff + 1));
    }
}
