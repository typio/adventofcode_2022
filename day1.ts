import * as fs from 'fs'

let dataString = fs.readFileSync('input.txt',
    { encoding: 'utf-8' })

let data = dataString.split('\n')
let calSums = (new Array(data.length)).fill(0)
let calSumsI = 0
data.forEach(s => {
    if (s === '') calSumsI++
    else calSums[calSumsI] += parseInt(s)
})

console.log(`highest calorie count: ${calSums.reduce(
    (prev, curr) => { return curr > prev ? curr : prev })}`);

let top3 = [0, 0, 0]
calSums.forEach(c => { // long but best O(n) 🤷‍♂️
    let usedC = false
    for (let i = 0; i < 3; i++)
        if (c > top3[i] && !usedC) {
            let usedOld = false
            for (let j = i; j < 3; j++) {
                if (top3[i] > top3[j] && !usedOld) {
                    top3[j] = top3[i]
                    usedOld = true
                }
            }
            top3[i] = c
            usedC = true
        }
})

console.log(`Highest 3 calorie counts: ${top3}, sum: ${top3.reduce(
    (prev, curr) => { return curr += prev })}`);

