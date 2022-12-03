import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

class RucksackReorg {
    private static int duplicatePrioritySum = 0;
    private static int badgePrioritySum = 0;
    private static int i = 0;

    public static void main(String[] args) {
        try {
            String[] lines = new String[3];
            Files.lines(Paths.get("day3_java/input.txt"))
                    .forEach(line -> {
                        duplicatePrioritySum += lookForDuplicatePriority(line);

                        lines[i % 3] = line;
                        i++;
                        if (i > 0 && i % 3 == 0) {
                            badgePrioritySum += lookForBadgePriority(lines);
                        }
                    });
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(duplicatePrioritySum);
        System.out.println(badgePrioritySum);
    }

    public static int getPriority(char item) {
        int n = item;
        return n >= 65 && n < 97 ? n - (65 - 27) : n - 96;
    }

    public static int lookForDuplicatePriority(String items) { // count sort!
        int middle = items.length() / 2;
        char[] firstItemsArr = items.substring(0, middle).toCharArray();
        char[] secondItemsArr = items.substring(middle).toCharArray();

        int firstCounts[] = new int[52];

        int p = 0;
        for (int i = 0; i < firstItemsArr.length; i++) {
            p = getPriority(firstItemsArr[i]);
            firstCounts[p - 1] = firstCounts[p - 1] + 1;
        }

        for (int i = 0; i < secondItemsArr.length; i++) {
            p = getPriority(secondItemsArr[i]);
            if (firstCounts[p - 1] > 0)
                return p;
        }

        return 0;
    }

    public static int lookForBadgePriority(String[] sacks) {
        char[] firstItemsArr = sacks[0].toCharArray();
        char[] secondItemsArr = sacks[1].toCharArray();
        char[] thirdItemsArr = sacks[2].toCharArray();

        int firstCounts[] = new int[52];
        int secondCounts[] = new int[52];

        int p = 0;
        for (int i = 0; i < firstItemsArr.length; i++) {
            p = getPriority(firstItemsArr[i]);
            firstCounts[p - 1] = firstCounts[p - 1] + 1;
        }

        for (int i = 0; i < secondItemsArr.length; i++) {
            p = getPriority(secondItemsArr[i]);
            secondCounts[p - 1] = secondCounts[p - 1] + 1;
        }

        for (int i = 0; i < thirdItemsArr.length; i++) {
            p = getPriority(thirdItemsArr[i]);
            if (firstCounts[p - 1] > 0 && secondCounts[p - 1] > 0)
                return p;
        }

        return 0;
    }

}