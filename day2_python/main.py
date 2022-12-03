import pandas as pd

if __name__ == '__main__':
    data = pd.read_csv('input.txt', sep=' ', header=None, names=['Elf', 'Me'])

    # part 1
    score = 0
    for i, row in data.iterrows():
        if row['Me'] == 'X':
            score += 1
            if row['Elf'] == 'A':
                score += 3
            elif row['Elf'] == 'B':
                score += 0
            elif row['Elf'] == 'C':
                score += 6
        elif row['Me'] == 'Y':
            score += 2
            if row['Elf'] == 'A':
                score += 6
            elif row['Elf'] == 'B':
                score += 3
            elif row['Elf'] == 'C':
                score += 0
        elif row['Me'] == 'Z':
            score += 3
            if row['Elf'] == 'A':
                score += 0
            elif row['Elf'] == 'B':
                score += 6
            elif row['Elf'] == 'C':
                score += 3
    print(score)

    # part 2
    score = 0
    for i, row in data.iterrows():
        if row['Me'] == 'X':
            score += 0
            if row['Elf'] == 'A':
                score += 3
            elif row['Elf'] == 'B':
                score += 1
            elif row['Elf'] == 'C':
                score += 2
        elif row['Me'] == 'Y':
            score += 3
            if row['Elf'] == 'A':
                score += 1
            elif row['Elf'] == 'B':
                score += 2
            elif row['Elf'] == 'C':
                score += 3
        elif row['Me'] == 'Z':
            score += 6
            if row['Elf'] == 'A':
                score += 2
            elif row['Elf'] == 'B':
                score += 3
            elif row['Elf'] == 'C':
                score += 1
    print(score)