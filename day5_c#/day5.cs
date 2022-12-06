using System.IO;
using System.Collections.Generic;

class day5 {
    static void Main(string[] args) {
        string filePath = "input.txt";
        string[] fileLines = File.ReadAllLines(filePath);

        List<string> stacks = new List<string>();

        bool readingMoves = false;
        foreach (string line in fileLines) {
            if (!readingMoves && line.Any(c => Char.IsNumber(c))) { // check if we done building init stacks
                readingMoves = true;
                // for (int i = 0; i < stacks.Count; i++) {
                //     Console.WriteLine(stacks[i] + " " + stacks[i].Length);
                // }
            } else if (!readingMoves) { // build initial stacks
                for (int i = 0; i < line.Length; i++) {
                    if ((i-1) % 4 == 0 && line[i] != ' ') {
                        while ((i-1) / 4 >= stacks.Count) {
                            stacks.Add("");
                        }
                        stacks[(i-1) / 4] = line[i] + stacks[(i-1) / 4];
                    }
                }
            } else { // move crates in stacks
                int[] numbers = new int[3];
                int buildingStrIdx = 0;
                bool isBuildingStr = false;
                string buildingStr = "";
                foreach (char c in line) {
                    if (Char.IsNumber(c)) {
                        isBuildingStr = true;
                        buildingStr = buildingStr + c;
                    } else if (isBuildingStr) {
                        isBuildingStr = false;
                        numbers[buildingStrIdx] = Int32.Parse(buildingStr);
                        buildingStr = "";
                        buildingStrIdx++;
                    }
                }
                if (buildingStr.Length > 0 && Char.IsNumber(buildingStr[0])) {                
                    numbers[buildingStrIdx] = Int32.Parse(buildingStr);

                // Console.WriteLine(numbers[0] + ", " + numbers[1] + ", " + numbers[2]);
                int quantity = numbers[0];
                string movingCrates = stacks[numbers[1] - 1].Substring(stacks[numbers[1] - 1].Length - quantity);
                // uncomment for part 1
                // char[] characters = movingCrates.ToCharArray();
                // Array.Reverse(characters);
                // movingCrates = String.Join("",characters);
                stacks[numbers[2] - 1] += movingCrates;
                stacks[numbers[1] - 1] = stacks[numbers[1] - 1].Remove(stacks[numbers[1] - 1].Length - quantity);
                }
            }            
        }

        string solution = "";
        foreach (string crates in stacks) {
                solution += crates[crates.Length-1];
        }
        Console.WriteLine("solution: " + solution);

        // foreach (string crates in stacks) {
        //         Console.WriteLine(crates);
        // }
    }
}
